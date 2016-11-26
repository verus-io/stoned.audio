$(document).ready ->
  m.on 'change', (k, v) ->
    if k == 'user.password'
      @data.set 'user.passwordConfirm', @data.get('user.password') or ''
      requestAnimationFrame ->
        Shop.cart.invoice()
        Shop.riot.update()
