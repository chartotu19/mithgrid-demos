MITHgrid.Application.namespace "gridDemo", (exp)->
	#Setting up the gridDemo app
	exp.initInstance = (args...)->
		# args... will contain the container and config if provided
		MITHgrid.Application.initInstance "MITHgrid.Application.gridDemo", arg..., (that,container)->

			# options comes from the MITHgrid.default[namespace]
			that.options = options

			# sets up the app
			that.ready ->
				
				# Create the input view


				#create bindings 

				#define events




MITHgrid.defaults "MITHgrid.Application.gridDemo",
	dataStores:
		csvData:

	dataView:
		inputList:

		csvData:

	presentations:
		inputList:
			type:MITHgrid.Presentation.List
			container:"#inputList"
			dataView:"inputList"
				options:
					googleDrive:
						id:"948087453516.apps.googleusercontent.com"
						enabled:true
					uploadCSV:
						enabled:true 
		opTable:
			type:MITHgrid.Presentation.Table
			container:"#opTable"
			dataView:"csvData"




