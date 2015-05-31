# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready( () ->
	$.getJSON '/api/users/with_progresses', (json) ->
		users = json.map( (d) -> d.name ).filter( (d, i, self) -> self.indexOf(d) == i )
		dateList = json.map( (d) -> d.updated_at.split('T')[0] ).filter( (d, i, self) -> self.indexOf(d) == i )

		rows = []
		rows.push ['x'].concat dateList

		users.forEach( (name, rowIndex) ->
			row = []
			dateList.forEach( (date, colIndex) ->
				row[0] = name
				row[colIndex + 1] =
					sum( json.filter( (d) -> d.name == name ).filter( (d) -> d.updated_at.split('T')[0] == date ).map( (d) -> d.progress_points ) )
			)
			rows.push(row)
		)
		draw rows
		return
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
        #legend: position: 'inset'
        subchart: show: true
    )

sum = (arr) ->
	arr.reduce ((prev, current, i, arr) ->
		prev + current
	), 0