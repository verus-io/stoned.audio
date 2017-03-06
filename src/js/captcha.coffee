$(document).ready ->
  return unless (['signup', 'checkout', 'ambassadors'].filter (v) -> ~location.pathname.indexOf v)

  readyCaptcha = (data)->
    requestAnimationFrame =>
      grecaptcha.render 'register-recaptcha',
        sitekey: '6LfX1hMUAAAAAAlNTjExftw7-GeykK2-tWjbtSUY'
        theme: 'dark'
        callback: (res)=>
          @data.set 'user.g-recaptcha-response', res

  m.on 'ready', readyCaptcha
  m.on 'submit-success', readyCaptcha
