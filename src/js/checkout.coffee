$document = $(document)

$document.ready ->
  window.Shop = Shop = require 'shop.js'
  window.selectize = require 'selectize'

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

  $document
    .on 'click', '.pre-order-button', window.openCheckout

    .on 'click', '.checkout button[type=submit]', ->
      if step == 2
        return true
      $inputs = $('user-name, user-email, card-number, card-expiry, card-cvc')
      inputCount = $inputs.length
      i = 0

      window.userExists = false

      validateFn = ->
        input = $inputs[i]
        if input
          pRef = {}
          input._tag.input.trigger 'validate', pRef

          if input._tag.lookup == 'user.email'
            pRef.p.then(window.client.account.exists(input._tag.value()).then (data)->
              window.userExists = data.exists
            )

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

    .on 'click', '.continue-shopping', (e) ->
      if step == 2
        step = 1
        $('.checkout').removeClass 'step-2'
        return false
      $modal.removeClass 'hidden'
      $modal.removeClass 'is-open'
      $('.checkout-container').css 'top', ''
      false

    .on 'keypress', 'promocode input', (e)->
      if e.which == 13
        requestAnimationFrame ->
          $('.promo-row button').click()

  m.on 'submit-success', ->
    $('.checkout').removeClass 'step-2'
    $('.checkout').addClass 'step-3'
    $('.thankyou strong').text @data.get('order.number')
    $('quantity-select-control .items').prop('disabled', true)

    Shop.analytics.track 'Completed Checkout Step', step: 3

    $('.modal-close').on 'click', (e) ->
      window.location.reload()
