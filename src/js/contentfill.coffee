# window.loads++

$(document).ready ->
  if !window.contentful
    return

  $('.contentful').each ->
    $el = $(this)
    template = $el.html()
    space = $el.attr('data-contentful-space')
    token = $el.attr('data-contentful-token')
    model = $el.attr('data-contentful-model')
    order = $el.attr('data-contentful-order')
    $el.html('')

    if !space or space == ''
      console.error 'No Contentful Space Specified'
      return
    if !token or token == ''
      console.error 'No Contentful Token Specified'
      return
    contentfulClient = contentful.createClient(
      accessToken: token
      space: space)
    contentfulClient.getEntries(content_type: model).then (entries) ->
      items = entries.items
      len = items.length
      if order and order != ''
        items.sort (a, b) ->
          a.fields[order] - (b.fields[order])
      else
        items.sort (a, b) ->
          new Date(a.sys.createdAt).getTime() - new Date(b.sys.createdAt).getTime()
      i = 0

      $el.siblings('.contentful-loading').remove()

      while i < len
        item = items[i]
        $template = $(template)
        do (i) ->
          $template.find('[data-contentful-field]').each (j) ->
            $field = $(this)
            field = $field.attr('data-contentful-field')
            $field.prepend item.fields[field]
            return
          $template.find('[data-contentful-src]').each (j) ->
            $field = $(this)
            field = $field.attr('data-contentful-src')
            if !item.fields[field] or !item.fields[field].fields or !item.fields[field].fields.file
              return
            $field.attr 'src', item.fields[field].fields.file.url
            return
          $template.find('[data-contentful-href]').each (i) ->
            $field = $(this)
            field = $field.attr('data-contentful-href')
            $field.attr 'href', item.fields[field]
            return
          return
          $template.find('[data-contentful-increment]').each (i) ->
            $field = $(this)
            attr = $field.attr('data-contentful-increment')
            $field.attr attr, $field.attr(attr) + i
            return
          return
        $el.append $template
        i++
      # window.loads--
      return
    return
  return
