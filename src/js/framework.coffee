window.loads = 0

$(document).ready ->
  # Modals
  $('.modal-open').on 'click', (e) ->
    $modalOpen = $(this)
    modalSelector = $modalOpen.attr('data-modal-selector')
    $modal = $(modalSelector).first()
    $('body').addClass 'modal-lock'
    $modal.removeClass 'hidden'

  $('.modal:not(.checkout-modal)').on 'scroll touchmove mousewheel', (e) ->
    e.preventDefault()
    e.stopPropagation()
    false

  $('.modal .content').on 'scroll touchmove mousewheel', (e) ->
    e.stopPropagation()
    true

  $('.modal-close').on 'click', (e) ->
    $modal = $(this).closest('.modal')
    $('body').removeClass 'modal-lock'
    $modal.addClass 'hidden'

  # Next Section
  $('.next-section').on 'click', (e) ->
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
  $('.button.call-to-action').on 'click', (e) ->
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
