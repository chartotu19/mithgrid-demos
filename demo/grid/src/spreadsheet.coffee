
MITHgrid.Presentation.namespace "Spreadsheet", (spreadsheet)->

  spreadsheet.initInstance = (args...) ->
    MITHgrid.Presentation.initInstance "MITHgrid.Presentation.Spreadsheet", args..., (that,container)->

      options = that.options
      #options
      #which columns to pick up from the datastore
      #the order of columns

      options.columns
      model = that.dataView

      _buffer = []
      i = 0


      newItem = (item)->
        if options.columns?
          i = 0
          _list = []
          while i < options.columns.length
            _list.push options.columns[i].data
            i++
          for key of item
            if _list.indexOf(key) is -1
              delete item[key]
        item

      #not sure
      # but without this that.render doesnt trigger
      that.hasLensFor = -> true

      #create the spreadsheet
      $(container).handsontable
        rowHeaders: true
        colHeaders: options.colHeaders
        columns:options.columns
        minSpareRows: 1
        columnSorting: options.columnSorting || false
        contextMenu: options.columnSorting || false

      handsontable = $(container).data "handsontable"

      that.render = (container,model,id)->
        columns = {}
        rendering = {}
        item = model.getItem id
        i++
        item = newItem item
        _buffer.push item
        _temp = _buffer.slice()
        handsontable.loadData _temp

        rendering.update = (item) ->
          console.log "Spreadsheet update"      
        rendering.remove = ->
          console.log "Spreadsheet remove"
      
        rendering
