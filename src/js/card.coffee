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

  $document = $(document)

  $document.ready ->
    $cardName = $('#card-name')

    updateCardName = ->
      name = $cardName.val()
      fontReady ->
        cardCtx.clearRect 0, 0, cardCanvas.width, cardCanvas.height
        cardCtx.font = '900 16px Lato'
        cardCtx.fillStyle = '#46BBA5'
        cardCtx.fillText name.toUpperCase(), 124, 378.5

        renderCtx.drawImage cardFull, 0, 0, 1280, 981
        renderCtx.font = '900 32px Lato'
        renderCtx.fillStyle = '#46BBA5'
        renderCtx.fillText name.toUpperCase(), 892, 758

    $downloadButton = $('a.download.button')

    updateRender = ->
      dataURL = renderCanvas.toDataURL 'image/png'
      $downloadButton.attr 'href', dataURL.replace('image/png', 'application/octet-stream')

    cardFull.onload = ->
      updateCardName()
    $cardName.on 'keyup', updateCardName
    $cardName.on 'change', updateRender
    $downloadButton.on 'click', updateRender
