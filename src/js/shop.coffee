$(document).ready ->
  window.Shop = Shop = require 'shop.js'
  window.selectize = require 'selectize'
  store = require 'shop.js/src/utils/store'

  settings =
    # prod live
    key: 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJiaXQiOjQ1MDM2MTcwNzU2NzUxNzIsImp0aSI6ImZBcnVLbXhLUXE0Iiwic3ViIjoiNE5UeFhsUXJ0YiJ9.fOUs-H-ALpW2LtZfwT7D1sAn3Ipq7NYvnTclRZGXwRK7XvIBBovQgjB8xmezllH65LYR6hl_Wz8tr6wREJV_OQ'
    endpoint: 'https://api.crowdstart.com'
    # prod test
    # key: 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJiaXQiOjQ1MDM2MTcwNzU2NzUxNzYsImp0aSI6InN6TFRXSnBhMms0Iiwic3ViIjoiNE5UeFhsUXJ0YiJ9.LeAFqqbKsxKCDJXHIoYJ3Ltt7qcN9K9lVmhDlQK-dimCn0MElregH6qm01sVrYE7We6Gm-4qh7dvMXO8WxAk0w'
    # endpoint: 'https://api.crowdstart.com'
    # staging test
    # key: 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJiaXQiOjQ1MDM2MTcwNzU2NzUxNzYsImp0aSI6IkJCMG56aTk4bVJFIiwic3ViIjoiNE5UeFhsUXJ0YiJ9.Ml2O8gHmL9jZ_LFRC_x-GRHFxd1xTyfRvWAnQgEkHk67RFDaR6v6bFOahmTG9G_nyu8d9_Y2qLqcFjjqm0HMzw'
    # endpoint: 'https://api.staging.crowdstart.com'
    order:
      metadata: batch: '2'
      shippingRate: 0
    terms: true
    referralProgram:
      id: 'Vm4tdRX5uO'
    taxRates: [
      {
        taxRate: 0.0275
        city: 'los angeles'
        state: 'ca'
        country: 'us'
      }
      {
        taxRate: 0.0625
        state: 'ca'
        country: 'us'
      }
      {
        taxRate: 0.08
        city: 'philadelphia'
        state: 'pa'
        country: 'us'
      }
      {
        taxRate: 0.06
        state: 'pa'
        country: 'us'
      }
    ]
    shippingRates: [
        # shippingRate: 500
        # country: 'us'
      # ,
        # shippingRate: 500
        # country: 'ca'
      # ,
        # shippingRate: 1500
    ]
    config: hashReferrer: true

  Shop.use Controls: Error: '' + '<div class="error" if="{ errorMessage }">' + '  { errorMessage }' + '</div>'
  m = window.m = Shop.start(settings)
  window.client = Shop.client

  $registerButton = $('register button[type=submit]')

  m.on 'register', ->
    $registerButton.prop('disabled', true)

  m.on 'register-success', ->
    window.location.replace 'account'

  m.on 'register-failed', ->
    $registerButton.prop('disabled', false)

  $loginButton = $('login button[type=submit]')

  m.on 'login', ->
    $loginButton.prop('disabled', true)

  m.on 'login-success', ->
    window.location.replace 'account'

  m.on 'login-failed', ->
    $loginButton.prop('disabled', false)

  m.on 'change', (k, v) ->
    if k == 'user.name'
      if !@data.get 'payment.account.name'
        @data.set 'payment.account.name', v
      if !@data.get 'order.shippingAddress.name'
        @data.set 'order.shippingAddress.name', v

    else if k == 'user.password'
      @data.set 'user.passwordConfirm', @data.get 'user.password'

    else if k == 'order.shippingAddress.country'
      if v == 'us'
        $('.tax-notice').hide()
      else
        $('.tax-notice').show()

    requestAnimationFrame ->
      Shop.cart.invoice()
      Shop.riot.update()

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



