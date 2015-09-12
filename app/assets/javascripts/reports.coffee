# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # For Markdown
  $('#title-view').text( $('#title').val() )
  convertMarkdown()
  $('#content').keyup( () -> convertMarkdown() )
  $('.like-active').on( 'click', (event) -> likeAction() ) # For 成長したねボタン
  new jBox('Tooltip', {attach: $('.like-active')})
  # For alert
  $('#notice.alert-success').addClass('animated flash').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', () ->
      $(this).removeClass('animated flash')
  ).delay(3000).hide(300)
  $('.close').on('click', () -> $('#notice.alert-success').hide() )
  # For textarea autoresize
  autosize($('textarea'))
  # For Clipboard
  clip()
  # For Favarite
  toggleFavor()

# For markdown
convertMarkdown = ->
  markdown = ''
  if $('#content').size() == 0 # showの場合
    markdown = $('#content-view').text().replace(/(^\s+)|(\s+$)/g, "")
  else # editの場合
    markdown = $('#content').val().replace(/(^\s+)|(\s+$)/g, "")
  # For highlight
  marked.setOptions langPrefix: ''
  $('#content-view').html(marked(markdown))
  # For highlight
  $('#content-view pre code').each (i, e) ->
    hljs.highlightBlock e, e.className
    return

# For typeahead of Tag
# https://twitter.github.io/typeahead.js/examples/
$( () ->
    $.getJSON('/reports/tagcount', (json) ->
      $('.typeahead').typeahead(
        source: json.map( (d) -> d.text )
        autoSelect: true
    )
  )
)

## For image file upload
$ ->
  $('.image-uploader-input').on('change', () ->
    data = new FormData()
    data.append('file', $('#image')[0].files[0])
    data.append('content_type', $('#image')[0].files[0].type)
    data.append('user_id', $('#report_user_id').val())
    $.ajax(
      url: '/images'
      type: 'POST'
      dataType: 'json'
      data: data
      processData: false
      contentType: false
    ).done( (d) ->
      org = $('#content').val()
      insertAtCaret( $('#content'), ('![' + d + '](' + location.protocol + '//' + location.host + '/images/show/' + d + ')') )
      convertMarkdown()
    )
  )

insertAtCaret = (target, str) ->
  target.focus()
  if navigator.userAgent.match(/MSIE/)
    r = document.selection.createRange()
    r.text = str
    r.select()
  else
    s = target.val()
    p = target.get(0).selectionStart
    np = p + str.length
    target.val( s.substr(0, p) + str + s.substr(p) )
    target.get(0).setSelectionRange( np, np )
  return

## For like button
likeAction = () ->
  return false if $('.like').hasClass('in-progress')
  $('.like').addClass('in-progress')
  $('.like-count').hide()
  $('.like').stop().animate({
      fontSize: '25rem'
  }, 100).animate({
      fontSize: '15rem'
  }, 100)

## For Clipboard
clip = () ->
  $('.clip').each( (i, v) ->
    $(v).attr('data-clipboard-text', location.href + '/' + $(v).text())
  )
  client = new ZeroClipboard( $('.clip') )
  new jBox('Modal', {
    attach: $('.clip'),
    content: 'クリップボードにレポートのURLをコピーしました'
  })

## For Favarite
toggleFavor = () ->
  $('[data-favarite]').on('click', () ->
    if $(this).data('favarite') == true
      unfavor($(this))
    else
      favor($(this))
    )

favor = (element) ->
  data =
    favarite:
      user_id: $('#user_id').text()
      report_id: element.data('reportId')
  $.ajax(
    url: '/favarites'
    type: 'POST'
    dataType: 'json'
    data: data
  ).done( (d) ->
    element.removeClass('lightgray-text')
    element.addClass('yellow-text')
    element.data('favarite', true)
    element.data('favariteId', d.id)
  )

unfavor = (element) ->
  $.ajax(
    url: '/favarites/' + element.data('favariteId')
    type: 'POST'
    data: {
      _method: 'delete'
      authenticity_token: $('#authenticity_token').val()
    }
  ).done( () ->
    element.removeClass('yellow-text')
    element.addClass('lightgray-text')
    element.data('favarite', false)
  )
