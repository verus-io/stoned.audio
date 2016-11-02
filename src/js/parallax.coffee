$(document).ready ->
  scheduled = false

  isFirefox = navigator.userAgent.toLowerCase().indexOf('firefox') > -1

  if isFirefox
    $els = $('.parallax .foreground')
    $els.each ->
      $el = $(this)
      yRatioStr = $el.attr 'data-ratio'
      if yRatioStr != ''
        $el.attr 'data-ratio', parseInt(yRatioStr, 10) - 100

  parallaxFn = ->
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
    return true

  parallaxFn()

  $(window).on 'scroll touchmove mousewheel', parallaxFn
