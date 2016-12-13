$document = $(document)
$document.ready ->
  opts = 'autoplay=1&showinfo=0&modestbranding=1&rel=0&loop=1'

  $document
    .on 'click', '.hero.video .play', (e) ->
      $hero = $(this).closest('.hero')
      $modal = $hero.find('.video-modal')
      $iframe = $modal.find('iframe')
      src = $hero.attr('data-src')
      $iframe.attr 'src', src + '?' + opts
      $modal.removeClass 'hidden'
      $('body').addClass 'modal-lock'
      e.stopPropagation()
      e.preventDefault()
      false

    .on 'click', '.hero.video .modal-close', (e) ->
      $modal = $(this).closest('.modal')
      # $modal.addClass('hidden');
      $iframe = $modal.find('iframe')
      $iframe.attr 'src', ''
      $('body').removeClass 'modal-lock'
