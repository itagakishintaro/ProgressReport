# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery -> 
	$('#title-view').text( $('#title').val() )
	convertMarkdown()
	$('#content').keyup( () -> convertMarkdown() )

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
    $.getJSON('/api/tags', (json) ->
        $('.typeahead').typeahead({
            source: json.map( (d) -> d.tag ),
            autoSelect: true
        })
    )
)


## For image file upload

jQuery -> 
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

			insertAtCaret( $('#content'), ('![' + d + '](http://localhost:3000/images/show/' + d + ')') )

			alert $('#content').val()
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
