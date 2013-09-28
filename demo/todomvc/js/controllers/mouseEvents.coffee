# Defining Click controller
MITHgrid.namespace "Click", (that)->
  that.initInstance= (args...)->
    MITHgrid.Controller.initInstance "MITHgrid.Click", args..., (that)->
      that.applyBindings = (binding)->
        binding.locate('clicker').click (e)->
          binding.events.onClick.fire(e)

# Defining Click controller
MITHgrid.namespace "DblClick", (that)->
  that.initInstance= (args...)->
    MITHgrid.Controller.initInstance "MITHgrid.DblClick", args..., (that)->
      that.applyBindings = (binding)->
        binding.locate('').dblclick (e)->
          binding.events.on.fire(e)

# Defining Keypress controller [Make it generic for any key]
MITHgrid.namespace "Enter", (that)->
  that.initInstance= (args...)->
    MITHgrid.Controller.initInstance "MITHgrid.Enter", args..., (that)->
      ENTER_KEY = 13
      that.applyBindings = (binding)->
        binding.locate('').blur (e)->
          binding.events.onEnter.fire e
        binding.locate('').keypress (e)->
          code = if e.keyCode then e.keyCode else e.which
          if code is ENTER_KEY
            binding.events.onEnter.fire(e)