if location.pathname.indexOf('checkout') >= 0
  $document = $(document)

  $document.ready ->
    show =  ->
      $('#page-checkout cart, #page-checkout checkout').addClass('animated fadeIn').css 'display', 'block'

    m.on 'ready', show

    setTimeout show, 1000

    m.on 'change', (k, v)->
      if k == 'user.email'
        window.client.account.exists(v).then (data)->
          window.userExists = data.exists

    m.on 'submit-success', (data)->
      $('#page-checkout .thankyou').addClass('animated fadeIn').css 'display', 'block'
      $('#page-checkout cart, #page-checkout checkout').css 'display', 'none'

