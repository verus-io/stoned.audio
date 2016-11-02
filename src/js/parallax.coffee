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
          yRatioStr = $el.attr 'data-ratio'
          if yRatioStr == ''
            yRatio = 100
          else
            yRatio = parseInt yRatioStr, 10

          yInitialStr = $el.attr 'data-initial-y'
          if yInitialStr == ''
            yInitial = 50
          else
            yInitial = parseInt yInitialStr, 10
          yOffset = yInitial + yRatio * (scrollTop - (offset.top)) / $el.height()
          $el.css 'background-position', '50% ' + yOffset + '%'
        scheduled = false
      scheduled = true
