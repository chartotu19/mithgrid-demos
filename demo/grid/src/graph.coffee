MITHgrid.Presentation.namespace "Graph" , (Graph)->

	Graph.initInstance  = (args...)->
	
		MITHgrid.Presentation.initInstance "MITHgrid.Presentation.Graph", args..., (that,container)->

			options = that.options

			model = that.dataView

			#Setting the default x-axis and y-axis values provided at initInstance 
			that.setxAxis(options.defaultxAxis)
			that.setyAxis(options.defaultyAxis)

			#creating control panel
			$(container).append("<div></div>")
			controls = $(container).find("div")
			
			#create svg
			$(container).append("<svg></svg>")

			# Not sure 
			that.hasLensFor = -> true

			# #listeners
			that.events.onxAxisChange.addListener ->
				that.drawPlot()

			that.events.onyAxisChange.addListener ->
				that.drawPlot()

			# creates the list of variables to be plotted
			pickup = ->
				excludeList = ["id","type","name"]
				includeList = []
				ids = that.dataView.items()
				#pick up the first id [Hack]
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
					$(celx).append("<option value='"+options.x[i]+"'>"+options.x[i]+"</option>")
					i++
				$(controls).append "<p>X-Axis :</p>"
				$(controls).append celx

				i = 0
				cely = $("<select class='y'></select>")
				while i < options.y.length
					$(cely).append("<option value='"+options.y[i]+"'>"+options.y[i]+"</option>")
					i++
				$(controls).append "<p>Y-Axis :</p>"
				$(controls).append cely

				celx.on "change", ->
					that.setxAxis $(this).val()

				cely.on "change", ->
					that.setyAxis $(this).val()

			updateSVG = (options)->
				#options is not used till now.
				options ?= {}
				xvar = that.getxAxis()
				yvar =  that.getyAxis()
				#clean the svg
				d3.select(container).select("svg").remove()
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
					d.name = model.getItem(items[i]).name
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
				updateSVG(options)
				# updateControls()

			that.render=(container,model,id)->
				rendering = {}
				updateControls()
				that.drawPlot()

				rendering.update = (item)->
					console.log "render.update called"

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


