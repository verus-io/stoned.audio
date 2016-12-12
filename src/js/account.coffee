if location.pathname.indexOf('account') >= 0
  Clipboard = require 'clipboard'

  $(document).ready ->
    if !window.client.client.customerToken
      window.location.replace 'signup'

    isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent)

    displayCopied = ->
      setTimeout (->
        $('.copied').css 'opacity', 1
        setTimeout (->
          $('.copied').css 'opacity', 0
        ), 1000
      ), 250

    # Copy link to clipboard and fade in message on click

    setupClipboard = ->
      new Clipboard('.ref-link', target: (trigger) ->
        if !isSafari
          displayCopied()
        $('.ref-link')[0]
    )
      return

    setupReferral = (url) ->
      $('#page-account .ref-text').html url
      url = encodeURIComponent(url)
      $('.share-facebook').attr 'href', 'https://www.facebook.com/sharer/sharer.php?u=' + url
      message = encodeURIComponent 'Get Stoned With Me!'
      $('.share-twitter').attr 'href', 'https://twitter.com/intent/tweet?text=' + message + '&amp;url=' + url
      setupClipboard()
      return

    m.on 'profile-load-failed', (err)->
      console.log err.stack
      # window.client.account.logout()
      # window.history.back()

    # m.on 'profile-load', ->

    m.on 'profile-load-success', (data)->
      setupReferral 'https://stoned.audio/#' + data.referrers[0].id

      store = require 'shop.js/src/utils/store'
      store.set 'register', true

      $('.ref-text').css 'opacity', 1

      points = data?.balances?.points
      points = 0 if !points

      $style = $('<style></style>')
      $('profile').append $style
      $style.html """
        .points-tracker:before {
          width: #{ points / 42 }% !important;
        }
      """

      $({points: 0}).animate {points: points},
        duration: 1000,
        step: ->
          $('#page-account .points').html Math.round(@points)

      $('.logout-button').on 'click', ->
        window.client.account.logout()
        window.location.replace '/'

      requestAnimationFrame ->
        $('shippingaddress button').on 'click', (e)->
          $el = $(e.target)
          requestAnimationFrame ->
            $el.prop('disabled', true).text 'Updating...'

          return true

    $button = $('#page-account button[type=submit]')
    m.on 'profile-update', (data)->
      $button.prop('disabled', true).find('span').text 'Updating...'

    m.on 'profile-update-success', (data)->
      $button.prop('disabled', false).find('span').text 'Updated!'

    m.on 'profile-update-failed', (err)->
      $button.prop('disabled', false).find('span').text 'Failed, Try Again.'

    m.on 'shipping-address-update-success', ->
      $('shippingaddress button').prop('disabled', false).text 'Updated!'

    m.on 'shipping-address-update-failed', ->
      $('shippingaddress button').prop('disabled', false).text 'Failed, Try Again.'

