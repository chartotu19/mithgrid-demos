###
Data Visualization Demo using MITHgrid.
@author: Selvam Palanimalai
###

MITHgrid.Application.namespace "gridDemo", (exp)->
	#Setting up the gridDemo app
	exp.initInstance = (args...)->
		# args... will contain the container and config if provided
		MITHgrid.Application.initInstance "MITHgrid.Application.gridDemo", args..., (that,container)->

			# sets up the app
			that.ready ->
				
				###Controller Initialization###
				clickInstance = MITHgrid.Click.initInstance(
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


				#2) Table Presentation
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

				#3) Spreadsheet Presentation
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
				# hide it initially. Onclick show.
				$(".csvTable").hide()
				
				#5) Graph Presentations
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

				#Template for parsing CSV. 
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

				#hook to play around in the console.	
				window["test"] = that 
				
				p['start'].done ->
					$(".message").hide()
					#create bindings 
					clickInstance.bind("#defUpload").events.onClick.addListener ->
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

					clickInstance.bind("#csvUpload").events.onClick.addListener ->
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
					clickInstance.bind("#csvExport").events.onClick.addListener ->
						csvExporter.export ","
					clickInstance.bind("#jsonExport").events.onClick.addListener ->
						jsonExporter.export ->
					handleFileSelect = (evt) ->
						evt.stopPropagation()
						evt.preventDefault()
						files = evt.dataTransfer.files # FileList object.
						# files is a FileList of File objects. List some properties.
						output = []
						i = 0

						f = files[0]
						output.push "<li><strong>", escape(f.name), "</strong> (", f.type or "n/a", ") - ", f.size, " bytes, last modified: ", (if f.lastModifiedDate then f.lastModifiedDate.toLocaleDateString() else "n/a"), "</li>"
						reader = new FileReader()
						reader.onloadend = (evt)->
							if evt.target.readyState is 2
								if evt.target.result? and JSON.parse?
									op = JSON.parse evt.target.result
									for o in op
										o.type = 'item'
									that.dataStore.csv.loadItems op
									$(".csvTable").show()
									$(".jsonTable").hide()
									$(".csvPlot").show()
									$(".jsonPlot").hide()
									$(".message").show().delay('1000').fadeOut('normal')
						
						reader.readAsText(f)
						document.getElementById("list").innerHTML = "<ul>" + output.join("") + "</ul>"
					
					handleDragOver = (evt) ->
					  evt.stopPropagation()
					  evt.preventDefault()
					  evt.dataTransfer.dropEffect = "copy" # Explicitly show this is a copy.

					# Setup the dnd listeners.
					dropZone = document.getElementById("drop_zone")
					dropZone.addEventListener "dragover", handleDragOver, false
					dropZone.addEventListener "drop", handleFileSelect, false



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

