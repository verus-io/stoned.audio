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
