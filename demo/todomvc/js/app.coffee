
#Application Definition
MITHgrid.Application.namespace 'todomvc', (exp)->
  exp.initInstance = (args...)->
    # args... will contain the container and config if provided
    MITHgrid.Application.initInstance 'MITHgrid.Application.todomvc', args..., (that,container)->

      that.ready ->
        window['test'] = that
        dataStore = that.dataStore.todolist

        #Presentation initialization.
        List = MITHgrid.Presentation.List.initInstance('#todo-list',
          dataView:that.dataView.todolistData
          getState:that.getState
        )

        #Load some data 
        item = [
          id:1
          text:'Get Milk!'
          type:'active'
        ,
          id:2
          text:'Book an appointment with doctor.'
          type:'active'
        ]
        
        dataStore.loadItems item
        exp = dataStore.prepare ['.type']
        
        #LISTENERS

        click = MITHgrid.Click.initInstance(
            selectors:
              'clicker':''
          )

        enter = MITHgrid.Enter.initInstance({})

        click.bind('#filters').events.onClick.addListener (e)->
          switch e.target.text 
            when 'Active' 
              that.setState 'active'
              List.selfRender()
            when 'All'
              that.setState 'all'
              List.selfRender()
            when 'Completed' 
              that.setState 'completed'
              List.selfRender()
        
        click.bind('#clear-completed').events.onClick.addListener (e)->
          for id in dataStore.items()
            if exp.evaluate(id)[0] is 'completed'
              dataStore.removeItems id         


        enter.bind('#new-todo').events.onEnter.addListener (e)->
          if (ref = e.target.value)?
            return false if ref.trim() is '' 
            ids = dataStore.items()
            item = 
              id: parseInt(ids[ids.length-1]) + 1
              type:'active'
              text:ref
            dataStore.loadItems [item]
            e.target.value = ''
        
        
        #Update counts in the footer [Should be replaced by the overview presentation]
        dataStore.events.onModelChange.addListener ->
          console.log 'something changed'
          active = 0
          completed = 0
          for id in dataStore.items()
            if exp.evaluate(id)[0] is 'active' then active += 1 else completed +=1
          that.setActive active
          that.setCompleted completed

        that.events.onActiveChange.addListener ->
          $('#todo-count').html('<strong>'+that.getActive()+'</strong> item left')

        that.events.onCompletedChange.addListener ->
          if that.getCompleted() is 0
            $('#clear-completed').html('')
          else
            $('#clear-completed').html('Clear completed ('+that.getCompleted()+')')

MITHgrid.defaults 'MITHgrid.Application.todomvc',
  variables:
    Active:
      'default':2
      is:'rw'
    Completed:
      'default':0
      is:'rw'
    State:
      'default':'all'
      is:'rw'

  dataStores:
    todolist:
      types:
        todo:{}
      properties:
        'text':
          valueType:'text'
 
  dataViews:
    todolistData:
      dataStore : 'todolist'
      type: ['completed','active']


MITHgrid.defaults 'MITHgrid.Click',
  selectors:
    'clicker':'.clicker'
  bind:
    events:
      onClick: null
MITHgrid.defaults 'MITHgrid.DblClick',
  bind:
    events:
      on: null
MITHgrid.defaults 'MITHgrid.Enter',
  bind:
    events:
      onEnter: null


#App initialised.
app = MITHgrid.Application.todomvc.initInstance 'todomvc', {}
app.run()

