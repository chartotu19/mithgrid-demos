MITHgrid.Presentation.namespace "editTable", (Table) ->
  Table.initInstance = (args...) ->
    MITHgrid.Presentation.initInstance "MITHgrid.Presentation.editTable", args..., (that, container) ->
      options = that.options
      
      tableEl = $("<table></table>")
      headerEl = $("<tr></tr>")
      tableEl.append(headerEl)

      dblclickInstance = MITHgrid.DblClick.initInstance({})

      blurInstance = MITHgrid.Blur.initInstance({})
      
      for c in options.columns
        headerEl.append("<th>#{options.columnLabels[c]}</th>")
      
      if options.editable is true
        headerEl.append('<i class="icon-plus" data-toggle="tooltip" id="add" title="first tooltip"></a>')

      $("#add").on "click", (e)->

      $(container).append(tableEl)
      
      that.hasLensFor = -> true
      
      stringify_list = (list) ->
        if list?
          list = [].concat list
          if list.length > 1
            lastV = list.pop()
            text = list.join(", ")
            if list.length > 1
              text = text + ", and " + lastV
            else
              text = text + " and " + lastV
          else
            text = list[0]
        else
          text = ""
        text
      
      that.render = (container, model, id) ->
        columns = {}
        rendering = {}
        el = $("<tr id=\""+id+"\"data-toggle='popover' data-html='true' data-content='<i class=\"rm icon-minus\" id=\"remove-"+id+"\"></i>' data-placement='right' ></tr>")
        rendering.el = el
        item = model.getItem id
        #
        # The `isEmpty` variable is a fix for a bug in the data store/view code that allows
        # an id to report as present even when the id has been deleted. 
        #
        isEmpty = true
        for c in options.columns
          cel = $("<td></td>")

          if item[c]?
            cel.append("<label for=\""+c+"\"></label><input/>")
            #append label and input only if property c is present.
            cel.find('label').html stringify_list item[c]
            cel.find('input').val(stringify_list item[c]).hide()
            isEmpty = false
          
            columns[c] = cel
          el.append(cel)
        if not isEmpty
          tableEl.append(el)
          # $(el).popover
          #     trigger:"hover"
          #     delay:  
          #       show: 0
          #       hide: 200
          dblclickInstance.bind("#"+id+" label").events.on.addListener (e)->
            # $(this).popover 'hide'
            $(e.target).hide()
            $(e.target.nextSibling).show()
          
          blurInstance.bind("#"+id+" input").events.onBlur.addListener (e)->
            code = if e.keyCode then e.keyCode else e.which
            if code is 13
              _input = $(e.target)
              _label = $(e.target.previousSibling)
              _label.html _input.val()
              obj = {}
              obj['id'] = id
              obj[_label.attr('for')] = _input.val()
              model.updateItems [obj] 
              _input.hide()
              _label.show()
        
          rendering.update = (item) ->
            for c in options.columns
              if item[c]?
                columns[c].find('label').html stringify_list item[c]
                columns[c].find('input').val stringify_list item[c]
        
          rendering.remove = ->
            el.hide()
            el.remove()
        
          rendering
        else
          el.remove()
          null