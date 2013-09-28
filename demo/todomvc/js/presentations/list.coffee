MITHgrid.Presentation.namespace 'List', (list)->
  list.initInstance = (args...)->
    MITHgrid.Presentation.initInstance 'MITHgrid.Presentation.List', args..., (that,container)->
      options = that.options
      container = that.container
      dataView = that.dataView
      getState = options.getState
      
      #Create controller instances
      clickInstance = MITHgrid.Click.initInstance(
          selectors:
            'clicker':''
        )
      dblclickInstance = MITHgrid.DblClick.initInstance({})
      keypressInstance = MITHgrid.Enter.initInstance({})
      
      that.hasLensFor = -> true

      # Toggle the type of the todo item [active,compeleted]
      toggle = (obj,id,el)->
        item = dataView.getItem id
        if obj.target.checked is true
          el.attr 'class','completed'
          dataView.updateItems [{id:id,type:'completed'}]
        else
          el.attr 'class','active'
          dataView.updateItems [{id:id,type:'active'}]
        
        
      #hooked to the remove button
      remove = (id)->
        dataView.removeItems id

      addClass = (el,type)->
        return false if !el?
        el.removeClass 'hidden'
        if (state = getState()) isnt 'all'
          if state is 'active' && type isnt 'active'
            el.addClass 'hidden'
          else if state is 'completed' && type isnt 'completed'
            el.addClass 'hidden'

      # This method returns a rendering object.
      # try to save all DOM specific data to this object.
      # This will reduce referencing DOM directly in the code.
      that.render = (container,model,id)->
        rendering = {}
        item = model.getItem id

        el = $('<li></li>')
        rendering.el = el
        el.attr 'class', item.type
        el.attr 'id', id
        el.append '<div class=\'view\'></div>' 
        el.append '<input class=\'edit\' value=' + item.text + '>'
        el[0].childNodes[1].value = item.text
        t = $('<input class=\'toggle\' type=\'checkbox\'>')
        if item.type is 'completed'
          t.attr 'checked',true
          el.find('div').append t
        else
          el.find('div').append t
        el.find('div').append '<label>' + item.text + '</label>'
        el.find('div').append '<button class=\'destroy\'></button>'

        # Add 'completed' or 'active' class to el.
        addClass el, item.type[0]

        $(container).prepend el

        # controller bindings 
        clickInstance.bind('#'+id+' .toggle').events.onClick.addListener (e)->
          toggle e,id,el

        clickInstance.bind('#'+id+' .destroy').events.onClick.addListener (e)->
          rendering.remove id
        
        dblclickInstance.bind('#'+id).events.on.addListener (e)->
          if (node = e.target.nodeName)?
            if node is 'LABEL'
              el.addClass 'editing'

        keypressInstance.bind('#'+id+' input').events.onEnter.addListener  (e)->
          el.removeClass 'editing'
          el.find('label').text e.target.value
          dataView.updateItems [{id:id, text:e.target.value}]

        rendering.update = (item) ->
          addClass el, item.type[0]

        rendering.remove = ->
          el.remove()
          remove id

        rendering
        
