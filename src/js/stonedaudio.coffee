import {requestTick} from './utils'

$document = $(document)
$document.ready ->
  emailRe = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/

  setTimeout ->
    $('.hero .foreground.product').addClass('animated')
  , 300

  $('.watch').on 'click', ->
    $(this).find('.play').click()

  $progress = $('.progress')
  sticky = false
  if $progress[0]
    progressFn = ->
      offset = $progress.offset()
      bottom = $(window).height() + $(window).scrollTop()
      if offset.top <= bottom && offset.top + 40 >= bottom
        $progress.find('.bar').css
          top: -40 + (bottom - $progress.offset().top)
        sticky = true
      else if (offset.top > bottom || offset.top + 40 < bottom) && sticky
        $progress.find('.bar').css
          top: ''
        sticky = false

    fn = ->
      requestTick progressFn
    $(window).on 'scroll touchmove mousewheel', fn

    fn()

  $('form#call-to-action').on 'submit', ->
    $form = $(this)

    $email = $form.find('#email')
    $error = $form.find('.error')
    $error.text ''

    email = $email.val()

    if emailRe.test email
      return true

    $error.text 'Enter a valid email.'
    return false

  if window.client.client.customerToken
    $('nav [href="/login"], menu [href="/login"]').attr('href', '/account').html 'ACCOUNT'

  $document.on 'click', '.share-coupon-button-for', (e) ->
    setTimeout ->
      $('.share-coupon .popup-text').hide()
      $('.share-coupon .popup-text.finished').show().css 'display', 'table'
    , 1000

  # figure out the page state/menu state
  $menuState = $('.menu-state')
  $menuState.on 'change', ->
    $el = $(this)
    val = $el.prop 'checked'
    $menuState.prop 'checked', false
    $el.prop 'checked', val
