
# Defining Click controller
MITHgrid.namespace "Click", (that)->
	that.initInstance= (args...)->
		MITHgrid.Controller.initInstance "MITHgrid.Click", args..., (that)->
			that.applyBindings = (binding)->
				binding.locate('').click (e)->
					binding.events.onSelect.fire e


MITHgrid.Application.namespace "gridDemo", (exp)->
	#Setting up the gridDemo app
	exp.initInstance = (args...)->
		# args... will contain the container and config if provided
		MITHgrid.Application.initInstance "MITHgrid.Application.gridDemo", args..., (that,container)->

			# options comes from the MITHgrid.default[namespace]
			#that.options = options
			# sets up the app
			that.ready ->
				
				###Controller Initialization###
				click = MITHgrid.Click.initInstance(
						selectors:
							"clicker":""
				)

				###Presentation Initialization###
				#1) Tab Presentation
				withTemplates = ['start','exportOptions']
				d = []
				p = []
				for t in withTemplates
					d[t] = new $.Deferred()
					p[t] = d[t].promise()

				MITHgrid.Presentation.Tabs.initInstance('.Tabs',
					dataView:that.dataView.jsonData
					nav:[
						id:'start'
						text:'Start/Import'
					,
						id:'data'
						text:'Data'
					,
						id:'visualize'
						text:'Visualize'
					,
						id:'exportOptions'
						text:'Export'
					]
					divs:[
						id:'start',
						containers:[
							class:'start'
							template:true
							promise:d['start']
						]
					,
						id:'data'
						containers:[
							class:'jsonTable'
							template:false
						, 
							class:'csvTable'
							template:false
						]
					,
						id:'visualize'
						containers:[
							class:'jsonPlot'
							template:false
						,
							class:'csvPlot'
							template:false
						]
					,
						id:'exportOptions'
						containers:[
							class:'export'
							template:true
							promise:d['exportOptions']
						]
					]
				)


				# Table presentation to show the data from JSON.
				MITHgrid.Presentation.editTable.initInstance('.jsonTable',
					columns: ["name","math","science","english"]
					columnLabels:
						name:"First Name"
						math:"Mathematics"
						science:"Science"
						english:"English"
					dataView:that.dataView.jsonData
				)

				# hide it initially. Onclick show.
				$(".jsonTable").hide()

				MITHgrid.Presentation.Spreadsheet.initInstance('.csvTable',
					dataView:that.dataView.csvData
					colHeaders: ["Name","Year","Popular Vote %","Popular vote Advantage",
						"Electoral vote Advantage",
						"Difference"
					]
					columnSorting:true
					columns:[
							data:"id"
						,
							data:"year"
						,
							data:"pop_vote_percentage"
						,	
							data:"pop_vote_advantage"
						,
							data:"elec_vote_advantage"
						,
							data:"difference"
					]
				)
				$(".csvTable").hide()
				
				# stats = MITHgrid.Presentation.SimpleText.initInstance('.stats',
				# 	dataView:that.dataView.csvData
				# )

				MITHgrid.Presentation.Graph.initInstance(".jsonPlot", 
					dataView:that.dataView.jsonData
					defaultxAxis:"math"
					defaultyAxis:"science"
				)

				MITHgrid.Presentation.Graph.initInstance(".csvPlot", 
					dataView:that.dataView.csvData
					defaultxAxis:"pop_vote_percentage"
					defaultyAxis:"elec_vote_advantage"
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

				template = 
					type: "president"
					separator: "  "
					columns:
						"id" : 0
						"year" : 1
						"pop_vote_percentage" : 2
						"pop_vote_advantage" : 3
						"elec_vote_percentage" : 4
						"elec_vote_advantage" : 5
						"difference" : 6

				importer = MITHgrid.Data.Importer.CSV.initInstance that.dataStore.csv, template

				csvExporter = null
				jsonExporter = null

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
				
				clickInstance = MITHgrid.Click.initInstance({})

				p['start'].done ->
					$(".message").hide()
					#create bindings 
					clickInstance.bind("#defUpload").events.onSelect.addListener ->
						#Upload the default data.
						#define callback.
						cb = (data)->
							#check for format
							if data?
								that.dataStore.json.loadItems data.entries
								jsonExporter = MITHgrid.Data.Exporter.JSON.initInstance that.dataStore.json, ()->
								csvExporter = MITHgrid.Data.Exporter.CSV.initInstance that.dataStore.json, ()->
								$(".csvTable").hide()
								$(".csvPlot").hide()
								$(".jsonPlot").show()
								$(".jsonTable").show()
								$(".message").show().delay('1000').fadeOut('normal')

						#make ajax call.
						$.ajax( 
							url:"data/test.json"
							type:"get"
							success:cb
						)

					clickInstance.bind("#csvUpload").events.onSelect.addListener ->
						#Upload the default data.
						#define callback.
						cb = (data)->
							#check for format
							if data?
								jsonExporter = MITHgrid.Data.Exporter.JSON.initInstance that.dataStore.csv, ()->
								csvExporter = MITHgrid.Data.Exporter.CSV.initInstance that.dataStore.csv, ()->
								$(".csvTable").show()
								$(".jsonTable").hide()
								$(".csvPlot").show()
								$(".jsonPlot").hide()
								$(".message").show().delay('1000').fadeOut('normal')
								importer.import data, ->
									console.log "success"

						#make ajax call.
						$.ajax( 
							url:"data/test.csv"
							type:"get"
							success:cb
						)

				p['exportOptions'].done ->
					clickInstance.bind("#csvExport").events.onSelect.addListener ->
						csvExporter.export ","
					clickInstance.bind("#jsonExport").events.onSelect.addListener ->
						jsonExporter.export ->



MITHgrid.defaults "MITHgrid.Application.gridDemo",
	# variables:
	# 	Avg:
	# 		"default":0
	# 		is:"rw"

	dataStores:
		json:
			types:
				student:{}
				record:{}
			properties:
				"name":
					valueType:"item"
		csv:
			types:
				president:{}
			properties:
				"year":
					valueType:"number"

	dataViews:
		jsonData:
			dataStore : "json"
			type: ["record","student"]
		csvData:
			dataStore: "csv"
			type: ["president"]


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

