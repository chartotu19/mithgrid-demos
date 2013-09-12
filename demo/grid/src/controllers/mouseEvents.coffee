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
MITHgrid.namespace "Blur", (that)->
  that.initInstance= (args...)->
    MITHgrid.Controller.initInstance "MITHgrid.Blur", args..., (that)->
      that.applyBindings = (binding)->
        binding.locate('').blur (e)->
          binding.events.onBlur.fire e
        binding.locate('').keypress (e)->
          code = if e.keyCode then e.keyCode else e.which
          if code is 13
            binding.events.onBlur.fire(e)

MITHgrid.defaults "MITHgrid.Click",
  selectors:
    "clicker":".clicker"
  bind:
    events:
      onClick: null
MITHgrid.defaults "MITHgrid.DblClick",
  bind:
    events:
      on: null
MITHgrid.defaults "MITHgrid.Blur",
  bind:
    events:
      onBlur: null