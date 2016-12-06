$(document).ready ->
  $menu = $('body > menu')
  $as = $menu.find('a')
  path = window.location.pathname.replace(/\/$/,'').toLowerCase()
  hasActive = false
  $as.each ->
    $el = $(this)
    href = $el.attr('href').replace(/\/$/,'').toLowerCase()
    name = $el.text().toLowerCase()
    if path.indexOf(href) == path.length - href.length || path.indexOf(name) == path.length - name.length
      $el.addClass 'active'
      hasActive = true
      return

  if !hasActive
    $menu.find('a[href="/"]').addClass 'active'
