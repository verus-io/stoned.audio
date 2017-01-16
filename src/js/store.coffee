$document = $(document)

$document.ready ->
  addItem = (item)->
    product = Shop.getItem(item)

    if !product
      quantity = 0
    else
      quantity = product.quantity

    if !quantity
      quantity = 0

    Shop.setItem item, quantity + 1

  $document.on 'click', '.buy-earphones', ->
    addItem 'earphone'

  .on 'click', '.buy-shirt', ->
    addItem 'shirt-black-m'

