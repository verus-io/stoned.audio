if location.pathname.indexOf('signup') >= 0 || location.pathname.indexOf('checkout') >= 0
  $(document).ready ->
    readyCaptcha = (data)->
      requestAnimationFrame ->
        grecaptcha.render 'register-recaptcha',
          sitekey: '6LfX1hMUAAAAAAlNTjExftw7-GeykK2-tWjbtSUY'
          theme: 'dark'
          callback: (res)=>
            @data.set 'user.g-recaptcha-response', res

    m.on 'ready', readyCaptcha
    m.on 'submit-success', readyCaptcha

