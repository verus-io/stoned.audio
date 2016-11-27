store = require 'shop.js/src/utils/store'
if store.get 'register'
  document.getElementById('login').checked=true

$(document).ready ->
  if location.pathname.indexOf('signup') >= 0
    m.on 'change', (k, v) ->
      if k == 'user.password'
        @data.set 'user.passwordConfirm', @data.get 'user.password'

    m.on 'register-success', ->
      store.set 'register', true
      window.location.replace 'account'

    m.on 'login-success', ->
      window.location.replace 'account'
