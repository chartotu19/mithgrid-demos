# Utility belt for MITHgrid.
# Add all reusable components.

MITHgrid.namespace "Utility", (Utility)->
    
    Utility.namespace "HashMap", (HashMap)->
      HashMap.initInstance = (options)->
        _list = []
        type = options.type || 'index'
        _search = (arr,val)->
          for i in [0..arr.length] by 1
            if arr[i] is val                   
              return i
          return false
        #
        # * key: key for which hash value is returned.  
        getHash:(key)->
          _search _list, key

        getKey:(hash)->
          if _list[hash]
            _list[hash]
          else
            false
        set:(key,value)->
          if type is 'index'
            _list.push key
