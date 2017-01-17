if location.pathname.indexOf('checkout') >= 0
  $document = $(document)

  $document.ready ->
    show =  ->
      $('#page-checkout cart, #page-checkout checkout').addClass('animated fadeIn').css 'display', 'block'

    m.on 'ready', show

    setTimeout show, 1000

