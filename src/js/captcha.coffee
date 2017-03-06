$(document).ready ->
  matches = ['signup', 'checkout', 'ambassadors'].filter (v) -> ~location.pathname.indexOf v

  return unless matches.length

  if matches[0] == 'ambassadors'
    theme = 'light'
  else
    theme = 'dark'

  readyCaptcha = (data) ->
    requestAnimationFrame =>
      grecaptcha.render 'register-recaptcha',
        sitekey: '6LfX1hMUAAAAAAlNTjExftw7-GeykK2-tWjbtSUY'
        theme:   theme
        callback: (res) =>
          @data.set 'user.g-recaptcha-response', res

  m.on 'ready', readyCaptcha
  m.on 'submit-success', readyCaptcha
