MITHgrid.Presentation.namespace "Tabs", (tabs)->

  tabs.initInstance = (args...)->
    MITHgrid.Presentation.initInstance "MITHgrid.Presentation.Tabs", args..., (that,container)->

      options = that.options
      #Not much use of dataView in this presentation.
      dataView = that.dataView

      that.hasLensFor = ->
        true
      
      container = $(container)
      ul = $("<ul class='nav nav-tabs'></ul>")
      divs = $("<div class='tab-content'></div>")
      
      #Tab content divs
      for item in options.divs
        _div = $("<div class='tab-pane' id='"+item.id+"'></div>")
        for c in item.containers
          _newDiv = document.createElement "div"
          _newDiv.className = c.class
          _div.append _newDiv
          if c.template is true
            url = "src/partials/"+c.class+".tmpl"
            $.get(url).success ((c,p) -> 
                (data) ->
                  console.log "get"+c
                  $("."+c).html data
                  # url = "src/controllers/"+c+".js"
                  # console.log url
                  # $.getScript(url,->
                  #   console.log "success"
                  # )
                  p.resolve()
              )(c.class,c.promise) 
        divs.append _div

      #Tab naivagation
      for item in options.nav
        ul.append "<li><a href='#"+item.id+"' data-toggle='tab'>"+item.text+"</a></li>"

      container.append ul
      container.append divs

      that.render = (container,model,id)->

        rendering = {}

        rendering.update = ->

        rendering.remove = ->

        rendering


