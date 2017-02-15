window.loads = 0

$document = $(document)
$document.ready ->
  # Modals

  $('.modal:not(.scrolling-modal)').on 'scroll touchmove mousewheel', (e) ->
    e.preventDefault()
    e.stopPropagation()
    false

  $('.modal .content').on 'scroll touchmove mousewheel', (e) ->
    e.stopPropagation()
    true

  $document
    .on 'click', '.modal-open', (e) ->
      $modalOpen = $(this)
      modalSelector = $modalOpen.attr('data-modal-selector')
      modalLock = $modalOpen.attr('data-modal-lock')
      $modal = $(modalSelector).first()
      if modalLock != 'false'
        $('body').addClass 'modal-lock'
      $modal.removeClass 'hidden'

    .on 'click', '.modal-close', (e) ->
      $modal = $(this).closest('.modal')
      if !$modal[0]
        $modal = $('.modal')
      $('body').removeClass 'modal-lock'
      $modal.addClass 'hidden'
      return false

  # Next Section
    .on 'click', '.next-section', (e) ->
      $section = $($(this).parents('section, .block').last())
      $nextSection = $($section).next()
      $nextSection = $nextSection.next() while $nextSection.attr('data-skip')

      if $nextSection.length != 0
        offset = ($(window).height() - $nextSection.height()) / 2
        $('html, body').animate { scrollTop: $nextSection.offset().top - offset }, 500
      e.preventDefault()
      e.stopPropagation()
      false

  # Default CTA jump behavior
    .on 'click', '.button.call-to-action', (e) ->
      $nextSection = $('#call-to-action')
      if $nextSection.length != 0
        offset = ($(window).height() - $nextSection.height()) / 2
        $('html, body').animate { scrollTop: $nextSection.offset().top - offset }, 1000
      e.preventDefault()
      e.stopPropagation()
      false

  # Loader
  intervalId = setInterval(->
    if window.loads == 0
      clearInterval intervalId
      $loader = $('loader')
      if $loader[0]
        $('.loader').fadeTo 1000, 0, ->
          $(this).hide()
          $('body').css 'overflow', ''
          return
      else
        $('body').css 'overflow', ''

      $('.ui-loader').remove()
  , 16)
