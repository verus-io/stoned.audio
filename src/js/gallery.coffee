$(document).ready ->
  iOS = /iPad|iPhone|iPod/.test(navigator.userAgent) and !window.MSStream
  controlsHTML = '<div class="gallery-controls"><div class="gallery-counter"></div><div class="gallery-before button">&lt</div><div class="gallery-after button">&gt</div></div>'
  itemHTML = '<div class="gallery-item"></div>'
  $galleries = $('.gallery')
  $galleries.each ->
    $gallery = $(this)
    $blocks = $gallery.children('section, .block')
    blockIndex = 0
    blockTotal = $blocks.length
    doFade = $gallery.attr('data-fade')
    $gallery.append $(controlsHTML)
    $controls = $gallery.find('.gallery-controls')
    $before = $gallery.find('.gallery-before')
    $after = $gallery.find('.gallery-after')
    $counter = $gallery.find('.gallery-counter')
    if iOS or doFade
      i = 0
      while i < blockTotal
        if i > 0
          $($blocks[i]).css 'opacity', '0'
        $counter.append $(itemHTML)
        i++
    else
      i = 0
      while i < blockTotal
        $($blocks[i]).css 'transform', 'translate3d(' + i * 100 + '%, 0, 0)'
        $counter.append $(itemHTML)
        i++
    $items = $counter.children('.gallery-item')

    updateFn = ->
      # $gallery.css('left', '-' + (100 * blockIndex) + '%');
      # $controls.css('transform', 'translateX(' + (100 * blockIndex) + '%)');
      if iOS or doFade
        i = 0
        while i < blockTotal
          $($blocks[i]).css 'opacity', 0
          i++
        $($blocks[blockIndex]).css 'opacity', 1
      else
        i = 0
        while i < blockTotal
          $($blocks[i]).css 'transform', 'translate3d(' + (i - blockIndex) * 100 + '%, 0, 0)'
          i++
      $before.css 'opacity', 1
      $after.css 'opacity', 1
      if blockIndex <= 0
        $before.css 'opacity', 0
      if blockIndex >= blockTotal - 1
        $after.css 'opacity', 0
      $items.removeClass 'active'
      $($items[blockIndex]).addClass 'active'
      return

    autoplayId = null

    leftFn = (e) ->
      if e
        clearInterval autoplayId
      if blockIndex > 0
        blockIndex--
      updateFn()
      return

    rightFn = (e) ->
      if e
        clearInterval autoplayId
      if blockIndex < blockTotal - 1
        blockIndex++
      updateFn()
      return

    autoplayMillis = $gallery.attr('data-autoplay')
    if autoplayMillis
      autoplayId = setInterval((->
        blockIndex = (blockIndex + 1) % blockTotal
        updateFn()
        return
      ), parseInt(autoplayMillis, 10))
    i = 0
    while i < blockTotal
      do (i) ->
        $($items[i]).on 'click', ->
          clearInterval autoplayId
          blockIndex = i
          updateFn()
          return
        return
      i++
    $before.on 'click', leftFn
    $after.on 'click', rightFn
    $gallery.on 'swipeLeft', leftFn
    $gallery.on 'swipeRight', rightFn
    updateFn()
    return
  return

