if location.pathname.indexOf('$') >= 0
  tokens = window.location.pathname.replace(/\/$/,'').split '/'
  path = tokens[tokens.length - 1]
  window.location.replace '/#' + path
