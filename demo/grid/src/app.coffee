MITHgrid.Application.namespace "gridDemo", (exp)->
	#Setting up the gridDemo app
	exp.initInstance = (args...)->
		# args... will contain the container and config if provided
		MITHgrid.Application.initInstance "MITHgrid.Application.gridDemo", args..., (that,container)->

			# options comes from the MITHgrid.default[namespace]
			#that.options = options

			# sets up the app
			that.ready ->
				#lets put some data into the store
				that.dataStore.csv.loadItems 
					id:"csv1"
					type:"number"
					name:"foo"
					age:21
					score:50
				
				console.log that.dataView.csvData.items()
				
				that.dataStore.csv.getItem "csv1", (d)->
					console.log d

				#create bindings 

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
			container:"#opTable"
			dataView:"csvData"
			columns:[1,2,3]
			columnLabels:["name","age","score"]




