# string contains
unless String::contains?
  if String::includes?
    String::contains = String::includes
  else
    String::contains = (s) ->
      (@indexOf s) != 1

# classlist contains
###
# classList.js: Cross-browser full element.classList implementation.
# 1.1.20150312
#
# By Eli Grey, http://eligrey.com
# License: Dedicated to the public domain.
#   See https://github.com/eligrey/classList.js/blob/master/LICENSE.md
###

###global self, document, DOMException ###

###! @source http://purl.eligrey.com/github/classList.js/blob/master/classList.js ###

if 'document' of self
  # Full polyfill for browsers with no classList support
  # Including IE < Edge missing SVGElement.classList
  if !('classList' of document.createElement('_')) or document.createElementNS and !('classList' of document.createElementNS('http://www.w3.org/2000/svg', 'g'))
    ((view) ->
      'use strict'
      if !('Element' of view)
        return
      classListProp = 'classList'
      protoProp = 'prototype'
      elemCtrProto = view.Element[protoProp]
      objCtr = Object
      strTrim = String[protoProp].trim or ->
        @replace /^\s+|\s+$/g, ''
      arrIndexOf = Array[protoProp].indexOf or (item) ->
        i = 0
        len = @length
        while i < len
          if i of this and @[i] == item
            return i
          i++
        -1

      DOMEx = (type, message) ->
        @name = type
        @code = DOMException[type]
        @message = message
        return

      checkTokenAndGetIndex = (classList, token) ->
        if token == ''
          throw new DOMEx('SYNTAX_ERR', 'An invalid or illegal string was specified')
        if /\s/.test(token)
          throw new DOMEx('INVALID_CHARACTER_ERR', 'String contains an invalid character')
        arrIndexOf.call classList, token

      ClassList = (elem) ->
        trimmedClasses = strTrim.call(elem.getAttribute('class') or '')
        classes = if trimmedClasses then trimmedClasses.split(/\s+/) else []
        i = 0
        len = classes.length
        while i < len
          @push classes[i]
          i++

        @_updateClassName = ->
          elem.setAttribute 'class', @toString()
          return

        return

      classListProto = ClassList[protoProp] = []

      classListGetter = ->
        new ClassList(this)

      # Most DOMException implementations don't allow calling DOMException's toString()
      # on non-DOMExceptions. Error's toString() is sufficient here.
      DOMEx[protoProp] = Error[protoProp]

      classListProto.item = (i) ->
        @[i] or null

      classListProto.contains = (token) ->
        token += ''
        checkTokenAndGetIndex(this, token) != -1

      classListProto.add = ->
        tokens = arguments
        i = 0
        l = tokens.length
        token = undefined
        updated = false
        loop
          token = tokens[i] + ''
          if checkTokenAndGetIndex(this, token) == -1
            @push token
            updated = true
          unless ++i < l
            break
        if updated
          @_updateClassName()
        return

      classListProto.remove = ->
        tokens = arguments
        i = 0
        l = tokens.length
        token = undefined
        updated = false
        index = undefined
        loop
          token = tokens[i] + ''
          index = checkTokenAndGetIndex(this, token)
          while index != -1
            @splice index, 1
            updated = true
            index = checkTokenAndGetIndex(this, token)
          unless ++i < l
            break
        if updated
          @_updateClassName()
        return

      classListProto.toggle = (token, force) ->
        token += ''
        result = @contains(token)
        method = if result then force != true and 'remove' else force != false and 'add'
        if method
          @[method] token
        if force == true or force == false
          force
        else
          !result

      classListProto.toString = ->
        @join ' '

      if objCtr.defineProperty
        classListPropDesc =
          get: classListGetter
          enumerable: true
          configurable: true
        try
          objCtr.defineProperty elemCtrProto, classListProp, classListPropDesc
        catch ex
          # IE 8 doesn't support enumerable:true
          if ex.number == -0x7FF5EC54
            classListPropDesc.enumerable = false
            objCtr.defineProperty elemCtrProto, classListProp, classListPropDesc
      else if objCtr[protoProp].__defineGetter__
        elemCtrProto.__defineGetter__ classListProp, classListGetter
      return
    ) self
  else
    # There is full or partial native classList support, so just check if we need
    # to normalize the add/remove and toggle APIs.
    do ->
      'use strict'
      testElement = document.createElement('_')
      testElement.classList.add 'c1', 'c2'
      # Polyfill for IE 10/11 and Firefox <26, where classList.add and
      # classList.remove exist but support only one argument at a time.
      if !testElement.classList.contains('c2')

        createMethod = (method) ->
          original = DOMTokenList.prototype[method]

          DOMTokenList.prototype[method] = (token) ->
            i = undefined
            len = arguments.length
            i = 0
            while i < len
              token = arguments[i]
              original.call this, token
              i++
            return

          return

        createMethod 'add'
        createMethod 'remove'
      testElement.classList.toggle 'c3', false
      # Polyfill for IE 10 and Firefox <24, where classList.toggle does not
      # support the second argument.
      if testElement.classList.contains('c3')
        _toggle = DOMTokenList::toggle

        DOMTokenList::toggle = (token, force) ->
          if 1 of arguments and !@contains(token) == !force
            force
          else
            _toggle.call this, token

      testElement = null
      return

# ---
# generated by js2coffee 2.2.0
