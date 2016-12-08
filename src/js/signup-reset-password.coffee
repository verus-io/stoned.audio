if location.pathname.indexOf('signup') >= 0 || location.pathname.indexOf('reset') >= 0
  store = require 'shop.js/src/utils/store'

  if store.get 'register'
    document.getElementById('login')?.checked=true

  $(document).ready ->
    if location.pathname.indexOf('signup') >= 0 && window.client.client.customerToken
      window.location.replace 'account'

    m.on 'change', (k, v) ->
      if k == 'user.password'
        @data.set 'user.passwordConfirm', @data.get 'user.password'

    m.on 'register-success', ->
      store.set 'register', true
      window.location.replace 'account'

    m.on 'login-success', ->
      window.location.replace 'account'

    $resetPasswordCompleteButton = $('reset-password button[type=submit]')
    m.on 'reset-password-complete', ->
      $resetPasswordCompleteButton.prop('disabled', true).text 'Resetting...'

    m.on 'reset-password-complete-success', ->
      window.location.replace 'account'
      $resetPasswordCompleteButton.prop('disabled', false).text 'Reset!'

    m.on 'reset-password-complete-failed', ->
      $resetPasswordCompleteButton.prop('disabled', false).text 'Failed, Try Again'

    m.on 'reset-password-success', ->
      window.location.href = 'reset-password-pending'


