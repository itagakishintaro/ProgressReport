$ ->
  # For alert
  $('#notice.alert-success').addClass('animated flash').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', () ->
    $(this).removeClass('animated flash')
  ).delay(3000).hide(300)
  $('.close').on('click', () -> $('#notice.alert-success').hide() )
# <----- websocket -----
  # dispatcher = new WebSocketRails('ws://localhost:3000/websocket')
  # channel = dispatcher.subscribe('streaming')
  # channel.bind 'create', (d) -> alert('ok')
  #----- websocket ----->
