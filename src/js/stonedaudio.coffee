$(document).ready ->
  setTimeout ->
    $('.hero .foreground.product').addClass('animated')
  , 300

  $('.watch').on 'click', ->
    $(this).find('.play').click()
