{requestTick} = require './utils'

$(document).ready ->
  setTimeout ->
    $('.hero .foreground.product').addClass('animated')
  , 300

  $('.watch').on 'click', ->
    $(this).find('.play').click()

  $progress = $('.progress')
  sticky = false
  progressFn = ->
    offset = $progress.offset()
    bottom = $(window).height() + $(window).scrollTop()
    if offset.top <= bottom && offset.top + 40 >= bottom
      $progress.find('.bar').css
        top: -40 + (bottom - $progress.offset().top)
      sticky = true
    else if (offset.top > bottom || offset.top + 40 < bottom) && sticky
      $progress.find('.bar').css
        top: ''
      sticky = false

  fn = ->
    requestTick progressFn
  $(window).on 'scroll touchmove mousewheel', fn

  fn()

