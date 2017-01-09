if location.pathname == '/'
  # http://solemone.de/code/code-examples/demos-grayscale-hover-effect-with-html5-canvas-and-jquery/
  grayScale = (src, cb)->
    supportsCanvas = !!document.createElement('canvas').getContext
    if supportsCanvas
      canvas = document.createElement 'canvas'
      context = canvas.getContext '2d'

      img = new Image()
      img.crossOrigin = 'Anonymous'
      img.src = src
      $(img).on 'load', ->
        canvas.width = img.width
        canvas.height = img.height
        context.drawImage(img, 0, 0)

        imageData = context.getImageData 0, 0, canvas.width, canvas.height
        px = imageData.data
        length = px.length

        i = 0
        while i < length
          gray = px[i] * .3 + px[i + 1] * .59 + px[i + 2] * .11
          px[i] = px[i + 1] = px[i + 2] = gray * .3
          i += 4

        context.putImageData imageData, 0, 0
        cb canvas.toDataURL()
    else
      cb img.src

  Instafeed = require 'instafeed.js'

  feed = new Instafeed
    get:            'user'
    userId:         '4001555412'
    accessToken:    '4001555412.5b2157e.acc6aa26ad4c4eecb3ed4ce7b6e7d6d8'
    resolution:     'standard_resolution'
    limit:          12
    after:          ->
      imgs = $('#instafeed img')
      i = 0
      if imgs[i]
        cb = (graySrc)->
          grayImg = new Image()
          grayImg.src = graySrc

          $(imgs[i]).parent().append grayImg

          i++

          if imgs[i]
            grayScale imgs[i].src, cb

        grayScale imgs[i].src, cb

  feed.run()
