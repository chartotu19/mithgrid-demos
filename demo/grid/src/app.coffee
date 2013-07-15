
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
					columns: ["name","age","math","science"]
					columnLabels:
						name:"First Name"
						age:"Age"
						math:"Mathematics"
						science:"Science"
				
					dataView:that.dataView.csvData
				)

				# stats = MITHgrid.Presentation.SimpleText.initInstance('.stats',
				# 	dataView:that.dataView.csvData
				# )

				MITHgrid.Presentation.Graph.initInstance(".plot", 
					dataView:that.dataView.csvData
				)
				# that.presentation.stats.addLens "number", (c,v,m,i)->
				# 	rendering = {}
				# 	items = m.getItems i
				# 	console.log items
				# 	el = $('<p>it works</p>')
				# 	$(c).append(el)
				# 	rendering.update =()->
				# 		$(c).append($('<p>updating</p>'))
				# 	rendering.remove = ()->
				# 		$(c).remove()
				# 	rendering
				exp = that.dataStore.csv.prepare ["!userName"]
				# Add listener to csv datastore update

				# calculateAvg = ->
				# 	items = that.dataStore.csv.items()
				# 	m = []
				# 	i = 0
				# 	while i < items.length
				# 		m.push that.dataStore.csv.getItem(items[i]).math[0]
				# 		i++
				# 	console.log m
				# 	t = 0
				# 	i = 0
				# 	while i < m.length
				# 		t = t + m[i]
				# 		i++
				# 	console.log t
				# 	t/m.length
					
				that.dataStore.csv.events.onModelChange.addListener ->
					console.log "model updated"
					# get the list of all math scores
					# avg = calculateAvg() 
					# that.setAvg avg


				# that.events.onAvgChange.addListener ->
				# 	$(".plot").html(that.getAvg())
				#Load some test data into the dataStore.
				#The Table view should dynamically change.
				
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
	# variables:
	# 	Avg:
	# 		"default":0
	# 		is:"rw"
	dataStores:
		csv:
			types:
				student:{}
				record:{}
			properties:
				"name":
					valueType:"item"

	dataViews:
		csvData:
			dataStore : "csv"
			type: ["record","student"]


	# presentations:
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
		# opTable:
		# 	type:MITHgrid.Presentation.Table
		# 	container:".opTable"
		# 	dataView:"csvData"
		# 	columns:[1,2,3,4]
		# 	columnLabels:["name","age","math","science"]

		# stats:
		# 	type:MITHgrid.Presentation.SimpleText
		# 	container:"#stats"
		# 	dataView:"csvData"
		# 	lensKey:["number"]



MITHgrid.defaults "MITHgrid.Click",
	bind:
		events:
			onSelect: null




