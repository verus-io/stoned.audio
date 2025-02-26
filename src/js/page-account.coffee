import Clipboard from 'clipboard'
import GMaps     from 'gmaps'
# import QRCode    from 'qrcode'
import store     from 'akasha'

if location.pathname.indexOf('account') >= 0
  # QRCodeDraw = new QRCode.QRCodeDraw()

  message = encodeURIComponent 'Get Stoned With Me!'

  $(document).ready ->
    if !window.client.client.customerToken
      window.location.replace 'login'

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

    setupReferral = (url) ->
      $canvas = $('.qrcode canvas')
      canvas = $canvas[0]

      if canvas?
        ctx = canvas.getContext '2d'
        ctx.imageSmoothingEnabled = false
        # QRCodeDraw.draw canvas, url, (error, canvas) ->
        #   if error
        #     console.error error

        #   dataUrl = canvas.toDataURL 'image/png'
        #   $('.qrcode img').attr 'src', dataUrl

        #   $('.qrcode .options .download').attr 'href', dataUrl.replace('image/png', 'application/octet-stream')
        #   $('.qrcode .options .print').on 'click', ->
        #     w = window.open '', 'w'
        #     w.document.write """
        #       <html>
        #         <head>
        #         <style type="text/css" media="print">
        #           @page { size: landscape; }
        #         </style>
        #         </head>
        #         <body>
        #           <img src="#{dataUrl}">
        #         </body>
        #       </html>"""
        #     w.window.print()

      $('.ref-text').html url
      url = encodeURIComponent(url)
      $('.share-facebook').attr 'href', 'https://www.facebook.com/sharer/sharer.php?u=' + url
      $('.share-twitter').attr 'href', 'https://twitter.com/intent/tweet?text=' + message + '&amp;url=' + url
      $('.share-email').attr 'href', 'mailto:?body=' + message + ' ' + url
      setupClipboard()
      return

    m.on 'profile-load-failed', (err)->
      console.log err.stack
      # window.client.account.logout()
      # window.history.back()

    # m.on 'profile-load', ->

    m.on 'profile-load-success', (data)->
      if data.affiliateId && data.affiliate.enabled
        $('.referrals.ambassador').addClass('show')

        for referrer in data.referrers
          if referrer.affiliateId == data.affiliateId
            setupReferral 'https://stoned.audio/$/' + data.referrers[0].id
            $('#affiliateReferralLink').val 'https://stoned.audio/$/' + referrer.id
            break

        if data.pendingFees?
          nextTransfer = 0
          for fee in data.pendingFees
            nextTransfer += fee.amount

          nextTransferStr = El.View.prototype.renderCurrency 'usd', nextTransfer

          $('.transfer-number').html nextTransferStr + ' USD'
      else
        $('.referrals.normal').addClass('show')
        setupReferral 'https://stoned.audio/$/' + data.referrers[0].id

      store.set 'register', true

      $('.ref-text').css 'opacity', 1

      points = data?.balances?.points
      points = 0 if !points

      # $style = $('<style></style>')
      # $('profile').append $style
      # $style.html """
      #   .points-tracker:before {
      #     width: #{ points / 42 }% !important;
      #   }
      # """

      $('.points-tracker li').each (i)->
        if (i + 1) * 840 <= points
          $el = $(this)
          do ($el)->
            setTimeout ->
              $el.addClass 'active'
            , i * 1000

      $('.points-tracker .points-bar-fill').each (i)->
        $el = $(this)
        do ($el)->
          if (i + 2) * 840 <= points
            setTimeout ->
              $el.css 'height', '100%'
            , i * 1000
          else
            setTimeout ->
              $el.css 'height', '' + ((points - 840 * (i+1)) / 840 * 100) + '%'
            , i * 1000

      $('#page-account .points').html Math.ceil points

      $('.logout-button').on 'click', ->
        window.client.account.logout()
        window.location.replace '/'

      requestAnimationFrame ->
        $('shippingaddress button').on 'click', (e)->
          $el = $(e.target)
          requestAnimationFrame ->
            $el.prop('disabled', true).text 'Updating...'

          return true

        $maps = $('.map')
        for mapEl in $maps
          do (mapEl) ->
            try
              mapJson = JSON.parse $(mapEl).attr 'data-address'

              mapJson.line1 ?= ''
              mapJson.line2 ?= ''
              mapJson.city ?= ''
              mapJson.state ?= ''
              mapJson.postalCode ?= ''
              mapJson.country ?= ''

              address = mapJson.line1 + ' ' +
                mapJson.line2 + ' ' +
                mapJson.city + ' ' +
                mapJson.state + ' ' +
                mapJson.postalCode + ' ' +
                mapJson.country

              GMaps.geocode
                address: address
                callback: (results, status) ->
                  if status == 'OK'
                    map = new GMaps
                      div: mapEl
                      lat: 21.3280681
                      lng: -157.798970564
                      zoom: 12
                      disableDefaultUI: true

                    latlng = results[0].geometry.location
                    map.removeMarkers()
                    map.addMarker
                      lat: latlng.lat()
                      lng: latlng.lng()

                    #terrible
                    $map = $(mapEl)
                    lastWidth = $map.width()

                    setInterval ->
                      map.setCenter latlng.lat(), latlng.lng()

                      width = $map.width()
                      if width == lastWidth
                        return

                      lastWidth = width
                      map.refresh()
                      map.setCenter latlng.lat(), latlng.lng()
                    , 500

            catch err
              console.log err

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
