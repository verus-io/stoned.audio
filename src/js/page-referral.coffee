if location.pathname.indexOf('referral') >= 0
  $(document).ready ->
    $('.points-tracker li').each (i)->
      $el = $(this)
      do ($el)->
        setTimeout ->
          $el.addClass 'active'
        , i * 1000

    $('.points-tracker .points-bar-fill').each (i)->
      $el = $(this)
      do ($el)->
        setTimeout ->
          $el.css 'height', '100%'
        , i * 1000
