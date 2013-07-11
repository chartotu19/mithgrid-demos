
# Defining Click controller
MITHgrid.namespace "Click", (that)->
	that.initInstance= (args...)->
		MITHgrid.Controller.initInstance "MITHgrid.Click", args..., (that)->
			that.applyBindings = (binding)->
				binding.locate('').click binding.events.onSelect.fire


MITHgrid.Application.namespace "gridDemo", (exp)->
	#Setting up the gridDemo app
	exp.initInstance = (args...)->
		# args... will contain the container and config if provided
		MITHgrid.Application.initInstance "MITHgrid.Application.gridDemo", args..., (that,container)->

			# options comes from the MITHgrid.default[namespace]
			#that.options = options
			# sets up the app
			that.ready ->
				
				#App is initialised

				#Presentation initialization
				opTable = MITHgrid.Presentation.Table.initInstance('.opTable',
					columns: ["userName","userAge","math","science"]
					columnLabels:
						userName:"First Name"
						userAge:"Age"
						math:"Mathematics"
						science:"Science"
				
					dataView:that.dataView.csvData
				)
				
				# Add listener to csv datastore update
				that.dataStore.csv.events.onModelChange.addListener ->
					console.log "model updated"
				
				#Load some test data into the dataStore.
				#The Table view should dynamically change.
				test = 

				#lets put some data into the store.
				that.dataStore.csv.loadItems [test]
				
				#hook to play around in the console.	
				window["test"] = that 

				#create bindings 
				binding = MITHgrid.Click.initInstance({}).bind("#defUpload")
				binding.events.onSelect.addListener ->
					#Upload the default data.
					#define callback.
					cb = (data)->
						#check for format
						if data?
							that.dataStore.csv.loadItems data.entries

					#make ajax call.
					$.ajax( 
						url:"data.json"
						type:"get"
						success:cb
					)

				#define events




MITHgrid.defaults "MITHgrid.Application.gridDemo",
	dataStores:
		csv:
			types:
				number:{}

	dataViews:
		csvData:
			dataStore : "csv"
			type: ["number"]


	presentations:
# 		inputList:
# 			type:MITHgrid.Presentation.List
# 			container:"#inputList"
# 			dataView:"inputList"
# 				# options:
# 				# 	googleDrive:
# 				# 		id:"948087453516.apps.googleusercontent.com"
# 				# 		enabled:true
# 				# 	uploadCSV:
# 				# 		enabled:true 
		opTable:
			type:MITHgrid.Presentation.Table
			container:".opTable"
			dataView:"csvData"
			columns:[1,2,3,4]
			columnLabels:["name","age","math","science"]

MITHgrid.defaults "MITHgrid.Click",
	bind:
		events:
			onSelect: null




