# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

sum = (arr) ->
  arr.reduce ((prev, current, i, arr) ->
    prev + current
  ), 0

drawChart = ->
  $.getJSON '/api/progresses', (json) ->
	  data = new (google.visualization.DataTable)
	  console.log(json)

	  users = json.map( (d) -> d.user ).filter( (d, i, self) -> self.indexOf(d) == i )
	  dateList = json.map( (d) -> d.time.split('T')[0] ).filter( (d, i, self) -> self.indexOf(d) == i )

	  # data.addColumn 'date', '日付'
	  data.addColumn 'string', '日付'
	  users.forEach( (d) -> data.addColumn 'number', d )
	  
	  rows = []
	  dateList.forEach( (date, rowIndex) ->
	    row = []
	    # row[0] = new Date(date)
	    row[0] = date
	    users.forEach( (user, colIndex) -> 
	      row[colIndex + 1] =
	        sum( json.filter( (d) -> d.time.split('T')[0] == date ).filter( (d) -> d.user == user ).map( (d) -> d.point ) )
	    )
	    rows.push(row)
	  )
	  
	  data.addRows rows
	  options = 
	    chart:
	      title: '成長グラフ'
	    width: 900
	    height: 500
	  chart = new (google.charts.Line)(document.getElementById('chart'))
	  chart.draw data, options
	  return
  return

google.load 'visualization', '1.1', packages: [ 'line' ]
google.setOnLoadCallback drawChart