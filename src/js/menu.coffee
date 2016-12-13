$(document).ready ->
  $menu = $('body > menu')
  $as = $menu.find('a')
  path = window.location.pathname.replace(/\/$/,'').toLowerCase()
  hasActive = false
  $as.each ->
    $el = $(this)
    href = $el.attr('href').replace(/\/$/,'').toLowerCase()
    name = $el.text().toLowerCase()
    hrefIndex = path.length - href.length
    nameIndex = path.length - name.length
    hrefRealIndex = path.indexOf(href)
    nameRealIndex = path.indexOf(name)
    if (hrefRealIndex == hrefIndex && hrefRealIndex >= 0) || (nameRealIndex == nameIndex && nameRealIndex >= 0)
      $el.addClass 'active'
      hasActive = true
      return

  if !hasActive
    $menu.find('a[href="/"]').addClass 'active'
