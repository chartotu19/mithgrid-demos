## CSV Exporter v0.1
# @license : MIT

MITHgrid.Data.namespace "Exporter", (E)->
  E.namespace "CSV", (csv)->
    csv.initInstance = (dataStore, template)->
      that= {}
      terminator = "\n"

      that.export = (separator,cb)->
        separator = separator || " "
        # get all items from the datastore
        ids = dataStore.items()
        #build the csv blob
        blob_val = ""
        if ids?.length isnt 0
          for id in ids
            temp = ""
            first_flag = true
            obj = dataStore.getItem id
            for key in Object.keys obj
              if first_flag is true
                temp = obj[key][0]
                first_flag = false
              else
                temp = temp+separator+obj[key][0]
            blob_val += temp + terminator

        blob = new Blob [blob_val], {type:"text/csv"} 
        saveAs(blob,"output.csv")

        #create synchronizer
        # syncer = MITHgrid.initSynchronizer()

      that
