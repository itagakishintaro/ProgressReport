# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready( () ->
	$.getJSON '/users/with_progresses', (json) ->
    users = json.map( (d) -> d.name ).filter( (d, i, self) -> self.indexOf(d) == i )

    jsonWithoutNull = json.filter( (d) -> d.updated_at ) # updated_atがnullのものはprogress pointsがないので除外
    dateList = jsonWithoutNull.map( (d) -> d.updated_at.split('T')[0] ).filter( (d, i, self) -> self.indexOf(d) == i )

    rows = []
    rows.push ['x'].concat dateList

    users.forEach( (name, rowIndex) ->
    	row = []
    	dateList.forEach( (date, colIndex) ->
    		row[0] = name
    		row[colIndex + 1] =
    			sum( jsonWithoutNull.filter( (d) -> d.name == name ).filter( (d) -> d.updated_at.split('T')[0] == date ).map( (d) -> d.point ) )
    	)
    	rows.push(row)
    )
    draw rows
    return
)

draw = (d) ->
	chart = c3.generate(
        data:
            x: 'x'
            columns: d
        axis:
            x:
                type: 'timeseries'
                tick:
                    format: '%Y-%m-%d'
            y:
                tick:
                    values: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100]
        #legend: position: 'inset'
        subchart: show: true
        size:
          height: 600
    )

sum = (arr) ->
	arr.reduce ((prev, current, i, arr) ->
		prev + current
	), 0
