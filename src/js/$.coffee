tokens = window.location.pathname.replace(/\/$/,'').split '/'
path = tokens[tokens.length - 1]
window.location.replace 'https://stoned.audio/#' + path
