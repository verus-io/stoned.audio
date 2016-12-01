if location.pathname.indexOf('account') >= 0
  Clipboard = require 'clipboard'

  $(document).ready ->
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
      # $('#fbLink').attr 'href', 'https://www.facebook.com/sharer/sharer.php?u=' + url
      # message = encodeURIComponent('Excited for the @JoinLudela launch! The world\'s first smartphone-controlled, real-flame candle is coming!')
      # $('#twLink').attr 'href', 'https://twitter.com/intent/tweet?text=' + message + '&amp;url=' + url
      setupClipboard()
      return

    if !window.client.client.customerToken
      window.location.replace 'signup'

    m.on 'profile-load-failed', (err)->
      console.log err.stack
      # window.client.account.logout()
      # window.history.back()

    # m.on 'profile-load', ->

    m.on 'profile-load-success', (data)->
      setupReferral 'https://stoned.audio/#' + data.referrers[0].id

      $('.ref-text').css 'opacity', 1

      points = data?.balances?.points
      points = 0 if !points

      $({points: 0}).animate {points: points},
        duration: 1000,
        step: ->
          $('#page-account .points').html Math.round(@points)

      $('a.logout').on 'click', ->
        window.client.account.logout()
        window.location.replace '/'

