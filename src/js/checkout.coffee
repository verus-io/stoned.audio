$ ->
  window.Shop = Shop = require 'shop.js'
  window.selectize = require 'selectize'

  settings =
    # prod live
    key: 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJiaXQiOjQ1MDM2MTcwNzU2NzUxNzIsImp0aSI6ImZBcnVLbXhLUXE0Iiwic3ViIjoiNE5UeFhsUXJ0YiJ9.fOUs-H-ALpW2LtZfwT7D1sAn3Ipq7NYvnTclRZGXwRK7XvIBBovQgjB8xmezllH65LYR6hl_Wz8tr6wREJV_OQ'
    # prod test
    # key: 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJiaXQiOjQ1MDM2MTcwNzU2NzUxNzYsImp0aSI6InN6TFRXSnBhMms0Iiwic3ViIjoiNE5UeFhsUXJ0YiJ9.LeAFqqbKsxKCDJXHIoYJ3Ltt7qcN9K9lVmhDlQK-dimCn0MElregH6qm01sVrYE7We6Gm-4qh7dvMXO8WxAk0w'
    endpoint: 'https://api.crowdstart.com'
    order:
      metadata: batch: 'preorder'
      shippingRate: 1000
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
      {
        shippingRate: 500
        country: 'us'
      }
      { shippingRate: 1500 }
    ]
    config: hashReferrer: true

  Shop.use Controls: Error: '' + '<div class="error" if="{ errorMessage }">' + '  { errorMessage }' + '</div>'
  m = window.m = Shop.start(settings)
  window.client = Shop.client
  step = 1

  Shop.setItem('earphone', 1)

  $modal = $('.checkout-modal.modal')
  $checkoutContainer = $('checkout-container')

  window.openCheckout = (e) ->
    $modal.addClass 'is-open'
    $modal.removeClass 'hidden'
    Shop.initCart()
    $('.checkout-container').css 'opacity', 1
    $('.checkout-container').css 'top', $(window).scrollTop() + 50
    Shop.analytics.track 'Viewed Checkout Step', step: 1
    Shop.analytics.track 'Completed Checkout Step', step: 1
    Shop.analytics.track 'Viewed Checkout Step', step: 2
    $('#general cart').removeClass 'show'
    $('#general cart').addClass 'hide'
    false

  $modal.find('.modal-close').on 'click', (e) ->
    $closestModal = $(this).closest('.modal')
    $closestModal.removeClass 'hidden'
    $closestModal.removeClass 'is-open'
    $('.checkout-container').css 'top', ''
    false

  $('.pre-order-button').on 'click', window.openCheckout

  $('button[type=submit]').on 'click', ->
    if step == 2
      return true
    $inputs = $('user-name, user-email, card-number, card-expiry, card-cvc')
    inputCount = $inputs.length
    i = 0

    validateFn = ->
      input = $inputs[i]
      if input
        pRef = {}
        input._tag.input.trigger 'validate', pRef
        pRef.p.then(->
          i++
          if i == inputCount
            step = 2
            Shop.analytics.track 'Completed Checkout Step', step: 2
            Shop.analytics.track 'Viewed Checkout Step', step: 3
            $('.checkout').addClass 'step-2'
          else
            validateFn()
          return
        ).catch (e) ->
          console.log e
          return
      return

    validateFn()
    false

  $('.continue-shopping').on 'click', (e) ->
    if step == 2
      step = 1
      $('.checkout').removeClass 'step-2'
      return false
    $modal.removeClass 'hidden'
    $modal.removeClass 'is-open'
    $('.checkout-container').css 'top', ''
    false

  m.on 'change', (k, v) ->
    if k == 'user.name'
      if !@data.get 'payment.account.name'
        @data.set 'payment.account.name', v
      if !@data.get 'order.shippingAddress.name'
        @data.set 'order.shippingAddress.name', v

    @data.set 'user.passwordConfirm', @data.get('user.password') or ''
    requestAnimationFrame ->
      Shop.cart.invoice()
      Shop.riot.update()
  enable = false

  m.on 'change-success', ->
    enable = true
    $('.email-form .form-submit').removeClass 'disabled'

  m.on 'submit-success', ->
    $('.checkout').removeClass 'step-2'
    $('.checkout').addClass 'step-3'
    $('.thankyou strong').text @data.get('order.number')
    $('quantity-select-control .items').prop('disabled', true)

    Shop.analytics.track 'Completed Checkout Step', step: 3

    $('.modal-close').on 'click', (e) ->
      window.location.reload()
      return
    return
  return
