import store from 'akasha'

if location.pathname.indexOf('login') >= 0 || location.pathname.indexOf('reset') >= 0
  if store.get 'register'
    document.getElementById('login')?.checked=true

  $(document).ready ->
    if location.pathname.indexOf('login') >= 0 && window.client.client.customerToken
      window.location.replace 'account'

    # m.on 'change', (k, v) ->
    #   if k == 'user.password'
    #     @data.set 'user.passwordConfirm', @data.get 'user.password'
