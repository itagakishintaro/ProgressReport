# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  select = (start, end) ->
    title = prompt('Title:')
    color = prompt('Color:')
    data = event:
      title: title
      start: start.format()
      end: end.format()
      color: color
      allDay: true
    data.event.allDay = false if start.format().match(/T/)
    if title
      $.ajax(
        url: '/events'
        type: 'POST'
        dataType: 'json'
        data: data
        ).done( (d) ->
          cal.fullCalendar('refetchEvents')
          return
        )
    cal.fullCalendar('unselect')
    return

  edit = (id, start, end) ->
    data = event:
      start: start.format()
      end: end.format()
    $.ajax(
      url: '/events/' + id
      type: 'PUT'
      dataType: 'JSON'
      data: data
      ).done( (d) ->
        cal.fullCalendar('refetchEvents')
        return
      )
    cal.fullCalendar('unselect')
    return

  cal = $('#calendar').fullCalendar
    header:
      left: 'prev,next today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    defaultView: 'agendaWeek'
    events: '/events.json'
    selectable: true
    selectHelper: true
    select: select
    editable: true
    eventLimit: true
    eventResize: (event, delta, revertFunc) ->
      edit(event.id, event.start, event.end)
    eventClick: (calEvent, jsEvent, view) ->
      event.preventDefault()
      location.href = '/events/' + calEvent.id + '/edit'
      return
  return
