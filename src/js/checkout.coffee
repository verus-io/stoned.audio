$ ->
  window.Shop = Shop = require 'shop.js'
  window.selectize = require 'selectize'

  settings =
    key: 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJiaXQiOjQ1MDM2MTcwNzU2NzUxNzYsImp0aSI6ImZnWGRlQ0p0Ml93Iiwic3ViIjoiNE5UeFhsUXJ0YiJ9.fU7jcJN4NtvrX4nLAarWwkfposl35-cM-uMFvMUaPvIW90WoCh5HIvabYMnoJW4GSqbrHA1jGNGRlEVxPpHDAA'
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
        shippingRate: 1000
        country: 'us'
      }
      { shippingRate: 2500 }
    ]
    config: hashReferrer: true

  Shop.use Controls: Error: '' + '<div class="error" if="{ errorMessage }">' + '  { errorMessage }' + '</div>'
  m = window.m = Shop.start(settings)
  window.client = Shop.client
  step = 1

  Shop.setItem('earphone', 1)

  $modal = $('.checkout-modal.modal')
  $thankyou = $('.thankyou')
  $checkoutContainer = $('checkout-container')

  window.openCheckout = (e) ->
    $modal.addClass 'is-open'
    $modal.removeClass 'hidden'
    Shop.initCart()
    $('.thankyou').hide()
    $('.checkout-container').css 'opacity', 1
    $('.checkout-container').css 'top', $(window).scrollTop() + 50
    $('.thankyou').css 'top', $(window).scrollTop() + 100
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
    $('.thankyou').css('top', '').hide()
    false
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
            $('checkout').addClass 'step-2'
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
      $('checkout').removeClass 'step-2'
      return false
    $modal.removeClass 'hidden'
    $modal.removeClass 'is-open'
    $('.checkout-container').css 'top', ''
    false

  m.on 'change', ->
    @data.set 'user.passwordConfirm', @data.get('user.password') or ''
    requestAnimationFrame ->
      Shop.cart.invoice()
      Shop.riot.update()
      return
    return
  enable = false

  m.on 'change-success', ->
    enable = true
    $('.email-form .form-submit').removeClass 'disabled'
    return

  m.on 'submit', ->
    $('.loader').show()
    setTimeout (->
      $('.loader').fadeTo 500, 0.8
      return
    ), 1
    return

  m.on 'submit-failed', ->
    $('.loader').fadeTo 500, 0, ->
      $(this).hide()
      return
    return

  m.on 'submit-success', ->
    $('.loader').fadeTo 500, 0, ->
      $(this).hide()
      return
    Shop.analytics.track 'Completed Checkout Step', step: 3
    $('.thankyou strong').text @data.get('order.number')
    $('.checkout-container').fadeTo 500, 0
    $('.thankyou').show()
    setTimeout (->
      $('.thankyou').fadeTo 500, 1, ->
      $('.loader').fadeTo 500, 0, ->
        $(this).hide()
        return
      return
    ), 100

    $('.modal-close').on 'click', (e) ->
      window.location.reload()
      return
    return
  return
