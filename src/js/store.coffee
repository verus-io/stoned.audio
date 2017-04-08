import Shop from 'shop.js'

# if location.pathname.indexOf('store') >= 0
if true

  $document = $(document)
  $document.ready ->
    max = 450
    min = 350

    rnd = ()->
      return Math.floor(Math.random() * (max - min)) + min

    stdSizeOptions =
      s: 'Small'
      m: 'Medium'
      l: 'Large'
      xl: 'X Large'
      xxl: 'XX Large'
      xxxl: 'XXX Large'

    colorOptions =
      black: "Black"
      white: "White"

    sizeIsRequired = (value)->
      return value if !value? || (value && value != '')

      throw new Error 'Select a size.'

    colorIsRequired = (value)->
      return value if !value? || (value && value != '')

      throw new Error 'Select a color.'

    CrowdControl = Shop.CrowdControl
    refer = Shop.Referential
    client = Shop.client

    class Product extends CrowdControl.Views.Form
      tag: 'product'
      id: 'product'
      name: ''
      description: ''
      buttonText: 'BUY NOW'

      backordered: false
      sizeOptions: stdSizeOptions
      colorOptions: colorOptions

      size: ''
      color: ''

      showSize: false
      showColor: false

      configs:
        color: [colorIsRequired]
        size: [sizeIsRequired]

      imgSrc: null

      loaded: false

      html: '''
        <div class="image animated fadeIn" if="{ loaded && imgSrc }">
          <img src="{ imgSrc }">
        </div>
        <div class="text animated fadeIn" if="{ loaded && !hideName }">
          <h2>{ data.get('name') }</h2>
        </div>
        <div class="animated fadeIn" if="{ loaded }">
          <div class="description" if="{ !showColor && !showSize }">
            { data.get('description') }
          </div>
          <div class="color options" if="{ showColor }">
            <span>
              <select-control select-options="{ colorOptions }" lookup="color" placeholder="Select a Color...">
              </select-control>
            </span>
          </div>
          <div class="size options" if="{ showSize }">
            <span>
              <select-control select-options="{ sizeOptions }" lookup="size" placeholder="Select a Size...">
              </select-control>
            </span>
          </div>
          <div class="prices">
            <div class>
              { renderCurrency(data.get('currency'), data.get('price')) } {data.get('currency').toUpperCase()}
            </div>
            <div if="{ data.get('price') < data.get('listPrice') }">
              { renderCurrency(data.get('currency'), data.get('listPrice')) } {data.get('currency').toUpperCase()}
            </div>
          </div>
          <div class="pre-order-button button" if="{ backordered }">
            <h3>SOLD OUT</h3>
          </div>
          <div class="pre-order-button button cart-peek" onclick="{ submit }" if="{ !backordered }">
            <h3>{ buttonText }</h3>
          </div>
        </div>
      '''

      getId: ()->
        id = @id

        if @data.get 'color'
          id += '-' + @data.get 'color'

        if @color
          id += '-' + @color

        if @data.get 'size'
          return id + '-' + @data.get 'size'

        if @size
          return id + '-' + @size

        return id

      init: ()->
        @data = refer {}

        @showSize = !!@size
        @showColor = !!@color

        dim = rnd()

        # @imgSrc = "http://placekitten.com/#{dim}/#{dim}" if !@imgSrc

        client.product.get(@getId()).then((res)=>
          @loaded = true
          @data.set res
          @data.set 'size', if @size then @size else null
          @data.set 'color', if @color then @color else null
          @size = null
          @color = null
          @data.set('name', @name) if @name
          @data.set('description', @description) if @description
          @update()

          requestAnimationFrame ()=>
            @update()
        ).catch (err)->
          console.log err

        # @on 'updated', ()->
        #   $('.store-grid .cards').packery
        #     itemSelector: '.card',
        #     gutter: 10

        super

      _submit: ()->
        item = Shop.getItem @getId()
        if !item || item.quantity <= 0
          Shop.setItem @getId(), 1
        else
          Shop.setItem @getId(), item.quantity + 1

        Shop.riot.update()
        return false

    Product.register()

    riot.mount 'product'
