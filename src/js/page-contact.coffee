import GMaps from 'gmaps'

if location.pathname.indexOf('contact') >= 0

  address = '405 Southwest Boulevard Suite 200 Kansas City, MO 64108 United States of America'

  GMaps.geocode
    address: address
    callback: (results, status) ->
      if status == 'OK'
        $map = $('.map')

        map = new GMaps
          div: $map[0]
          lat: 21.3280681
          lng: -157.798970564
          zoom: 14
          disableDefaultUI: true
          draggable: false
          zoomControl: false
          scrollwheel: false
          disableDoubleClickZoom: true

        latlng = results[0].geometry.location
        map.removeMarkers()
        map.addMarker
          lat: latlng.lat()
          lng: latlng.lng()

        #terrible
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
