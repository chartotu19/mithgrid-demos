## CSV Importer v0.1
# @license : MIT

MITHgrid.Data.namespace "Importer", (I)->
	I.namespace "CSV", (csv)->
		csv.initInstance = (dataStore, template)->
			that= {}
			items = []
			ids = []

			that.import = (csv,cb)->
				cb = (ids)->
					console.log ids
				#logic to parse the csv
				subjects = $.csv2Array csv, 
					separator: template.separator

				#create synchronizer
				syncer = MITHgrid.initSynchronizer()

				#register the process
				syncer.process subjects, (s)->
					item = {}
					id = null
					item.type = template.type
					#compare with template and build item
					for key of template.columns
						value = template.columns[key]
						if s[value]?
							if key is "id"
								id = s[value]
							item[key] = s[value]
					items.push item
					ids.push id

				syncer.done ->
					setTimeout ->
						_updateList = []
						_loadList = []
						for item in items
							if dataStore.contains [item]
								_updateList.push item
							else
								_loadList.push item
						dataStore.updateItems _updateList if _updateList.length isnt 0
						dataStore.loadItems _loadList if _loadList.length isnt 0
						cb(ids) if cb? 
					,0
			that
