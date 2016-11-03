{requestTick} = require './utils'

translateY = ($el, val) ->
  translate = "translate3d(0px, -#{val}px, 0)"

  el = $el[0]
  el.style.transform = translate

  for prefix in ['webkit', 'moz', 'ms', 'o']
    el.style["-#{prefix}-transform"] = translate

  return

updatePosition = ($el) ->
  offset = window.pageYOffset
  val = offset - (offset * $el.ratio)
  val = 0 if val < 0
  translateY($el, val)
  return

parallax = (selector) ->
  $els = ($(el) for el in $(selector))

  for $el in $els
    $el.ratio = (parseInt ($el.attr 'data-ratio'), 10) * 0.01

  ->
    requestTick ->
      updatePosition $el for $el in $els
      return
    true

$(document).ready ->
  fn = parallax '.parallax .foreground'
  $(window).on 'scroll touchmove mousewheel', fn
  fn()
