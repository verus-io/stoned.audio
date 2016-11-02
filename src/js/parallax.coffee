$(document).ready ->
  scheduled = false

  $(window).on 'scroll touchmove mousewheel', ->
    if !scheduled
      requestAnimationFrame ->
        $els = $('.parallax .foreground')
        scrollTop = $(this).scrollTop()
        $els.each ->
          $el = $(this)
          offset = $el.offset()
          yOffset = 50 + 100 * (scrollTop - (offset.top)) / $el.height()
          $el.css 'background-position', '50% ' + yOffset + '%'
        scheduled = false
      scheduled = true
