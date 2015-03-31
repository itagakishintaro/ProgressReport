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
	$('#content-view').html(marked(markdown))

convertMarkdown()
$( () -> $('#content').keyup( () -> convertMarkdown() ) )