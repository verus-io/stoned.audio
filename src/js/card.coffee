if location.pathname.indexOf('card') >= 0
  FontFaceObserver = require 'fontfaceobserver'
  font = new FontFaceObserver 'Lato',
    weight: 900

  fontReady = (fn)->
    font.load().then fn

  cardCanvas = document.getElementById 'card-canvas'
  cardCtx = cardCanvas.getContext '2d'
  cardCtx.imageSmoothingEnabled = false

  # cardFront = new Image()
  # cardFront.src = '/img/holiday/2016card-front.png'
  # cardFront.onload = ->
  #   cardCtx.drawImage cardFront, 0, 0, 640, 981

  renderCanvas = document.getElementById 'render-canvas'
  renderCtx = renderCanvas.getContext '2d'
  renderCtx.imageSmoothingEnabled = false

  cardFull = new Image()
  cardFull.src = '/img/holiday/2016card.png'

  z =
    readyFn: ->
      requestAnimationFrame z.readyFn

  cardFull.onload = z.readyFn

  $document = $(document)

  $document.ready ->
    $cardName = $('#card-name')

    updateCardName = ->
      name = $cardName.val()
      fontReady ->
        cardCtx.clearRect 0, 0, cardCanvas.width, cardCanvas.height
        cardCtx.font = '900 16px Lato'
        cardCtx.fillStyle = '#46BBA5'
        cardCtx.fillText 'GET READY TO', 58, 326.5
        cardCtx.fillText 'GET STONED!', 68, 352.5
        cardCtx.fillText 'LOVE, ' + name.toUpperCase(), 78, 378.5

        renderCtx.drawImage cardFull, 0, 0, 1280, 981
        renderCtx.font = '900 32px Lato'
        renderCtx.fillStyle = '#46BBA5'
        renderCtx.fillText 'GET READY TO', 756, 653
        renderCtx.fillText 'GET STONED!', 776, 705
        renderCtx.fillText 'LOVE, ' + name.toUpperCase(), 796, 757

    $downloadButton = $('a.download.button')
    $printButton = $('.print')

    updateRender = ->
      dataURL = renderCanvas.toDataURL 'image/png'
      $downloadButton.attr 'href', dataURL.replace('image/png', 'application/octet-stream')

    z.readyFn = ->
      updateCardName()
      updateRender()

    updateCardName()

    $cardName.on 'keyup', updateCardName
    $cardName.on 'change', updateRender
    $downloadButton.on 'click', updateRender

    $printButton.on 'click', ->
      dataUrl = $downloadButton.attr 'href'
      w = window.open '', 'w'
      w.document.write """
        <html>
          <head>
          <style type="text/css" media="print">
            @page { size: landscape; }
          </style>
          </head>
          <body>
            <img src="#{dataUrl.replace('application/octet-stream', 'image/png')}">
          </body>
        </html>"""
      w.window.print()
