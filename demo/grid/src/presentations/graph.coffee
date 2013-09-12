MITHgrid.Presentation.namespace "Graph" , (Graph)->
  # ## Graph
  #
  # A graph presentation provides a graphical view of the data. 
  # Currently supports scatter,multibar,line plots. 
  #
  # Options:
  # 
  # * defaultxAxis: Parameter on the x-axis. 
  # * defaultyAxis: Parameter on the y-axis. (both have to be one of the properties of the dataView item)
  # * plotType: [optional] type of graph/plot
  #
  # The list of variables are picked up from the dataStore (Excluding the name,id,type properties).
  #
  # **N.B.:** This presentation is a work in progress.
	Graph.initInstance  = (args...)->
	
		MITHgrid.Presentation.initInstance "MITHgrid.Presentation.Graph", args..., (that,container)->

			# Fetch options from the instantiation
			options = that.options
			model = that.dataView

			# set plotType to default if none provided
			options.plotType = options.plotType || that.getType()

			# Keep updating this list as more plotTypes are supported
			supportedTypes = ["scatter","line","multiBar"]

			#Setting the default x-axis and y-axis values provided at initInstance 
			that.setxAxis(options.defaultxAxis)
			that.setyAxis(options.defaultyAxis)

			#creating control panel
			dom = $(container).append("<div class=\"graph-controls\"></div>")
			controls = $(container).find("div")
			
			#create svg
			$(container).append("<svg></svg>")

			that.hasLensFor = -> true

			# Listeners
			# Onchange of any of the controls, replot the graph.
			that.events.onxAxisChange.addListener ->
				that.drawPlot()
			that.events.onyAxisChange.addListener ->
				that.drawPlot()
			that.events.onTypeChange.addListener ->
				that.drawPlot()

			# creates the list of variables to be plotted
			pickup = ->
				#common properties in an item which needs to be ignored from variable list.
				excludeList = ["id","type","name"]
				includeList = []
				ids = that.dataView.items()
				#pick up the first id to get the variable list [Hack]
				if ids[0]?
					res = that.dataView.getItem(ids[0])
				if res?
					entries = Object.keys(res)
					i = 0
					while i < entries.length
						if excludeList.indexOf(entries[i]) is -1
							includeList.push entries[i]
						i++
				includeList

			updateControls = ()->
				controls.empty()
				#check if x is available
				if not options.x?
					# need to pick the whole list from the dataView
					options.x = pickup().slice(0)

				if not options.y?
					# need to pick the whole list from the dataView
					options.y = pickup().slice(0)

				i = 0
				celx = $("<select class='x'></select>")
				while i < options.x.length
					if options.x[i] is options.defaultxAxis
						selected = "selected"
					else
						selected = ""
					$(celx).append("<option value='"+options.x[i]+"' "+selected+" >"+options.x[i]+"</option>")
					i++
				x_cont = $('<div class=\"x-container\"></div>')
				x_cont.append '<span>X-Axis :</span>'
				x_cont.append celx
				$(controls).append x_cont

				i = 0
				cely = $("<select class='y'></select>")
				while i < options.y.length
					if options.y[i] is options.defaultyAxis
						selected = "selected"
					else
						selected = ""
					$(cely).append("<option value='"+options.y[i]+"' "+selected+">"+options.y[i]+"</option>")
					i++
				y_cont = $('<div class=\"y-container\"></div>')
				y_cont.append '<span>Y-Axis :</span>'
				y_cont.append cely
				$(controls).append y_cont

				i = 0
				type = $("<select class='plotType'></select>")
				while i < supportedTypes.length
					if supportedTypes[i] is options.plotType
						selected = "selected"
					else
						selected = ""
					$(type).append("<option value='"+supportedTypes[i]+"' "+selected+">"+supportedTypes[i]+"</option>")
					i++
				$(controls).append "<span>Plot Type :</span>"
				$(controls).append type

				celx.on "change", ->
					that.setxAxis $(this).val()

				cely.on "change", ->
					that.setyAxis $(this).val()

				type.on "change", ->
					that.setType $(this).val()

			linePlot = (options)->
				d3.select(container).select("svg").remove()
				margin =
				  top: 20
				  right: 80
				  bottom: 30
				  left: 50

				width = 960 - margin.left - margin.right
				height = 500 - margin.top - margin.bottom
				svg = d3.select(container).append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")

				
				d3.json "data/cumulativeLineData.json", (data) ->
					nv.addGraph ->
					  #adjusting, 100% is 1.00, not 100 as it is in the data
					  chart = nv.models.cumulativeLineChart().x((d) ->
					    d[0]
					  ).y((d) ->
					    d[1] / 100
					  ).color(d3.scale.category10().range())
					  chart.xAxis.tickFormat (d) ->
					    d3.time.format("%x") new Date(d)

					  chart.yAxis.tickFormat d3.format(",.1%")
					  d3.select(container).select("svg").datum(data).transition().duration(500).call chart
					  
					  #TODO: Figure out a good way to do this automatically
					  nv.utils.windowResize chart.update
					  chart

			multiBarPlot = ->
				dom.find('.x-container').hide()
				dom.find('.y-container').hide()
				d3.select(container).select('svg').remove()
				nv.addGraph ->
				  chart = nv.models.multiBarChart()
				  chart.xAxis.tickFormat d3.format(',f')
				  chart.yAxis.tickFormat d3.format(',.1f')
				  d3.select(container).append('svg').datum(data()).transition().duration(500).call chart
				  nv.utils.windowResize chart.update
				  chart

				hash = ->
					_list = []
					_count = 0
					get:(id)->
						#check for id
						if _list[id]?
							_list[id]
						else
							_list[id] = _count + 1
							_count++
			
				data = ->
				  h = hash()
				  result = []
				  items = model.items()
				  ref = model.getItem(model.items()[0])
				  result = []
				  i = 0
				  _results = []
				  while i < Object.keys(ref).length
				    obj = {}
				    obj.values = []
				    obj.key = _key = Object.keys(ref)[i]
				    # if key is not present in the includeList returned by pickup().
				    # continue in the loop.
				    if !(_key in pickup())
				    	i++
				    	continue
				    j = 0
				    while j < items.length
				      _id = items[j]
				      val = model.getItem(_id)
				      temp = {}
				      temp.y = val[_key] or 0
				      temp.x = h.get(_id)
				      obj.values.push temp  if ((if temp? then temp.y else undefined))?
				      j++
				    result.push(obj)
				    i++
				  result

			scatterPlot = (options)->
				dom.find('.x-container').show()
				dom.find('.y-container').show()
				#options is not used till now.
				options ?= {}
				xvar = that.getxAxis()
				yvar =  that.getyAxis()
				#clean the svg
				d3.select(container).select('svg').remove()
				#svg specs
				margin =
					top: 20
					right: 20
					bottom: 30
					left: 40
				width = 960 - margin.left - margin.right
				height = 500 - margin.top - margin.bottom

				x = d3.scale.linear().range([0, width])
				y = d3.scale.linear().range([height, 0])
				color = d3.scale.category10()
				xAxis = d3.svg.axis().scale(x).orient("bottom")
				yAxis = d3.svg.axis().scale(y).orient("left")
				svg = d3.select(container).append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")
				
				#get the list of items
				items = model.items()
				i = 0
				data = []
				while i < items.length
					d = {}
					d[xvar] = model.getItem(items[i])[xvar]
					d[yvar]= model.getItem(items[i])[yvar]
					d.name = model.getItem(items[i]).name || model.getItem(items[i]).id 
					data.push d
					i++
				x.domain(d3.extent(data, (d) ->
					d[xvar]
				)).nice()
				y.domain(d3.extent(data, (d) ->
					d[yvar]
				)).nice()
				svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call(xAxis).append("text").attr("class", "label").attr("x", width).attr("y", -6).style("text-anchor", "end").text xvar
				svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("class", "label").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text yvar
				svg.selectAll(".dot").data(data).enter().append("circle").attr("class", "dot").attr("r", 6).style("opacity", 0.5).attr("cx", (d) ->
					x d[xvar]
				).attr("cy", (d) ->
					y d[yvar]
				).style "fill", (d) ->
					color d.name

				legend = svg.selectAll(".legend").data(color.domain()).enter().append("g").attr("class", "legend").attr("transform", (d, i) ->
					"translate(0," + i * 20 + ")"
				)
				legend.append("rect").attr("x", width - 18).attr("width", 18).attr("height", 18).style "fill", color
				legend.append("text").attr("x", width - 24).attr("y", 9).attr("dy", ".35em").style("text-anchor", "end").text (d) ->
					d
				dots = svg.selectAll(".dot")
				mouseOn = ()->
					dot = d3.select(this)
					dot.transition()
					.duration(800).style("opacity", 1)
					.attr("r", 12).ease("elastic")
					#x-axis guide line
					svg.append("g").attr("class", "guide").append("line").attr("x1", dot.attr("cx")).attr("x2", dot.attr("cx")).attr("y1", +dot.attr("cy") + 16).attr("y2", height).style("stroke", dot.style("fill")).transition().delay(200).duration(400)
					#y-axis guide line
					svg.append("g").attr("class", "guide").append("line").attr("x1", +dot.attr("cx") - 16).attr("x2", 0).attr("y1", dot.attr("cy")).attr("y2", dot.attr("cy")).style("stroke", dot.style("fill")).transition().delay(200).duration(400)

				mouseOff = ()->
					d3.select(this).transition()
					.duration(800).style("opacity", .5)
					.attr("r", 6).ease("elastic")

					d3.selectAll(".guide").transition().duration(100).styleTween("opacity", ->
					  d3.interpolate .5, 0
					).remove()
				# Bind mouse events 
				dots.on("mouseover", mouseOn)
				dots.on("mouseout", mouseOff)


			that.drawPlot = (options)->
				switch that.getType() 
					when 'scatter'
						scatterPlot options
					when 'line'
						linePlot options
					when 'multiBar'
						multiBarPlot options
				# updateControls()

			that.render=(container,model,id)->
				console.log "graph render called"
				rendering = {}
				updateControls()
				that.drawPlot()

				rendering.update = (item)->
					console.log "graph update called"
					updateControls()
					that.drawPlot()

				rendering.remove = ->
					$(container).remove()

				#return
				rendering
				
MITHgrid.defaults "MITHgrid.Presentation.Graph", 
	variables:
		xAxis:
			"default":null
			"is":"rw"
		yAxis:
			"default":null
			"is":"rw"
		Type:
			"default":"scatter"
			"is":"rw"

