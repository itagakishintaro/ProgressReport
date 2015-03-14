# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# jQuery markdown2html
$('#title-view').text( $('#title').val() )
markdown = ''
if $('#content').size() == 0 
	markdown = $('#content-view').text().replace(/(^\s+)|(\s+$)/g, "")
else
	markdown = $('#content').text().replace(/(^\s+)|(\s+$)/g, "")
$('#content-view').html(marked(markdown))


# for angular.js
myApp = angular.module('myApp', [])
myApp.controller('EditingReportController', ($scope) ->
	html = $scope.content
)