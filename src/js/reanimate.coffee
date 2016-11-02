# Trigger Animate.css animation when it gets scrolled to.
$(document).ready ->
  $('.animated').each ->
    $animated = $(this)
    scheduled = false
    animation = $animated.css('animation-name')
    $animated.removeClass animation
    $(window).on 'scroll touchmove mousewheel', ->
      if !scheduled
        requestAnimationFrame ->
          offset = $animated.offset()
          if offset.top < $(window).height() + $(window).scrollTop()
            $animated.addClass animation
          else
            scheduled = false
          return
        scheduled = true
      return
    return
  return
