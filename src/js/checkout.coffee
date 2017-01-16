$document = $(document)

$document.ready ->
  Clipboard = require 'clipboard'
  window.Shop = Shop = require 'shop.js'
  window.selectize = require 'selectize'

  step = 1
  message = encodeURIComponent 'Get Stoned With Me!'
  isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent)

  # Shop.setItem('earphone', 1)

  $modal = $('.checkout-modal.modal')
  $checkoutContainer = $('.checkout-container')

  displayCopied = ->
    setTimeout (->
      $('.copied').css 'opacity', 1
      setTimeout (->
        $('.copied').css 'opacity', 0
      ), 1000
    ), 250

  setupClipboard = ->
    new Clipboard('.ref-link', target: (trigger) ->
      if !isSafari
        displayCopied()
      $('.ref-link')[0]
  )

  setupReferral = (url) ->
    $('.ref-text').html url
    url = encodeURIComponent(url)
    $('.share-facebook').attr 'href', 'https://www.facebook.com/sharer/sharer.php?u=' + url
    $('.share-twitter').attr 'href', 'https://twitter.com/intent/tweet?text=' + message + '&amp;url=' + url
    $('.share-email').attr 'href', 'mailto:?body=' + message + ' ' + url
    setupClipboard()

  window.openCheckout = (e) ->
    $modal.addClass 'is-open'
    $modal.removeClass 'hidden'
    Shop.initCart()
    $checkoutContainer.css 'opacity', 1
    $checkoutContainer.css 'top', $(window).scrollTop() + 50
    Shop.analytics.track 'Viewed Checkout Step', step: 1
    Shop.analytics.track 'Completed Checkout Step', step: 1
    Shop.analytics.track 'Viewed Checkout Step', step: 2
    $('#general cart').removeClass 'show'
    $('#general cart').addClass 'hide'
    $('#open-cart').prop 'checked', false
    false

  $document
    .on 'click', '.checkout-modal.modal .modal-close, .checkout-container .modal-close', (e) ->
      $closestModal = $(this).closest('.modal')
      if !$closestModal[0]
        $closestModal = $('.modal')
      $closestModal.removeClass 'hidden'
      $closestModal.removeClass 'is-open'
      $checkoutContainer.css 'top', ''
      false

    # .on 'click', '.pre-order-button', window.openCheckout

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
      $checkoutContainer.css 'top', ''
      false

    .on 'keypress', 'promocode input', (e)->
      if e.which == 13
        requestAnimationFrame ->
          $('.promo-row button').click()

  m.on 'submit-success', (data)->
    $('.checkout').removeClass 'step-2'
    $('.checkout').addClass 'step-3'
    $('.thankyou strong').text @data.get('order.number')
    $('quantity-select-control .items').prop('disabled', true)

    Shop.analytics.track 'Completed Checkout Step', step: 3

    setupReferral 'https://stoned.audio/$/' + @data.get('referrerId')
    $('.ref-text').css 'opacity', 1

    $document.on 'click', '.modal-close', (e) ->
      window.location.reload()
