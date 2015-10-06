$ ->
  # For alert
  $('#notice.alert-success').addClass('animated flash').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', () ->
    $(this).removeClass('animated flash')
  ).delay(3000).hide(300)
  $('.close').on('click', () -> $('#notice.alert-success').hide() )
