if location.pathname.indexOf('review') >= 0
  $document = $(document)
  $document.ready ->
    $document.on 'click', '.gem', ->
      $el = $(this)
      $el.parent().children().removeClass 'selected'
      $el.addClass 'selected'

    .on 'click', '#submit', ->
      opts =
        userId:     $('#email').val()
        name:       $('#name').val()
        comment:    $('#comment').val()
        rating:     $('.gem.selected').index() + 1

        'g-recaptcha-response': $('#g-recaptcha-response').val()

      console.log opts

      window.client.review.create(opts).then (data)->
        $('.body .content').html '<h1>THANKS!</h1>'
