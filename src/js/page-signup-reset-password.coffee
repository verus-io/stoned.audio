if location.pathname.indexOf('signup') >= 0
  $(document).ready ->
    m.on 'ready', (data)->
      grecaptcha.render 'register-recaptcha',
        sitekey: '6LfX1hMUAAAAAAlNTjExftw7-GeykK2-tWjbtSUY'
        theme: 'dark'
        callback: (res)=>
          @data.set 'user.g-recaptcha-response', res

if location.pathname.indexOf('login') >= 0 || location.pathname.indexOf('reset') >= 0
  store = require 'shop.js/src/utils/store'

  if store.get 'register'
    document.getElementById('login')?.checked=true

  $(document).ready ->
    if location.pathname.indexOf('login') >= 0 && window.client.client.customerToken
      window.location.replace 'account'

    # m.on 'change', (k, v) ->
    #   if k == 'user.password'
    #     @data.set 'user.passwordConfirm', @data.get 'user.password'
