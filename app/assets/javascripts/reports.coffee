# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('#title-view').text( $('#title').val() )

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

convertMarkdown()
$('#content').keyup( () -> convertMarkdown() )


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