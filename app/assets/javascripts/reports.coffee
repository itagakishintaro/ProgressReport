# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

lastWatchTime = 0
$ -> 
	# For Markdown
	$('#title-view').text( $('#title').val() )
	convertMarkdown()
	$('#content').keyup( () -> convertMarkdown() )
	
	# For Notice
	lastWatchTime = getLastWatchTime()
	$('#notice').on('click', () -> 
		setLastWatchTime( new XDate().getTime() )
		latestNotice = 0
		setNotice()
	)

# For notice
getLastWatchTime = () ->
	return 0

setLastWatchTime = (last) ->

setNotice = () ->
	$('#notice-body').empty()
	setXForUser('comments', $('#user_id').text())
	setXForUser('progresses', $('#user_id').text())

setXForUser = (x, user) ->
	$.getJSON("/#{x}/for_user/#{user}", (json) ->
		report_id_list = json.map( (v, i) ->
			return v.report_id # report_idだけの配列にして
		).filter( (x, i, self) ->
            return self.indexOf(x) == i # 重複を排除
        )
        
		report_id_list.forEach( (report_id, i) ->
			at = Math.max.apply(null, json.filter( (v) ->
				return v.report_id == report_id
			).map( (o) ->
				return new XDate(o.updated_at).getTime()
			))
			watched = ''
			watched = ' watched' if at < lastWatchTime
			open = '<div class="notice-row' + watched + '" data-at="' + at + '"><a href="/reports/' + report_id + '">'
			body = ''

			xJa = 'コメント' if x == 'comments'
			xJa = '成長したね' if x == 'progresses'
			close = "があなたのレポートに#{xJa}しました。</a></div>"
			
			json.filter( (v) ->
				return v.report_id == report_id # report_idで絞って
			).map( (v, i) ->
				return v.user_name # user_nameだけの配列にして
			).filter( (x, i, self) ->
		        return self.indexOf(x) == i # 重複を排除して
		    ).forEach( (v, i) ->
				body += "#{v}さん " # 名前を追記する
			)

			$('#notice-body').append(open + body + close)
		)

		sortNoticeBody()
	)

sortNoticeBody = () ->
	sorted = $('#notice-body').children().sort( (a, b) -> return $(b).data('at') - $(a).data('at') )
	$('#notice-body').html(sorted)
	latestNotice = $('#notice-body div:first-child').data('at')

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
    $.getJSON('/reports/tags', (json) ->
        $('.typeahead').typeahead({
            source: json.map( (d) -> d.tag ),
            autoSelect: true
        })
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
			insertAtCaret( $('#content'), ('![' + d + '](http://localhost:3000/images/show/' + d + ')') )
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
