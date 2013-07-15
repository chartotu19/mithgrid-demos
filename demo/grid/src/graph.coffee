MITHgrid.Presentation.namespace "Graph" , (Graph)->

	Graph.initInstance  = (args...)->
	
		MITHgrid.Presentation.initInstance "MITHgrid.Presentation.Graph", args..., (that,container)->

			options = that.options

			# Not sure 
			that.hasLensFor = -> true

			#create svg
			$(container).append("<svg></svg>")

			console.log "Graph initInstance"
			that.render=(container,model,id)->
				rendering = {}
				console.log "graph render called"
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
					d.science = model.getItem(items[i]).science
					d.math = model.getItem(items[i]).math
					d.name = model.getItem(items[i]).name
					data.push d
					i++
				x.domain(d3.extent(data, (d) ->
					d.science
				)).nice()
				y.domain(d3.extent(data, (d) ->
					d.math
				)).nice()
				svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call(xAxis).append("text").attr("class", "label").attr("x", width).attr("y", -6).style("text-anchor", "end").text "science"
				svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("class", "label").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text "Math"
				svg.selectAll(".dot").data(data).enter().append("circle").attr("class", "dot").attr("r", 6).style("opacity", 0.5).attr("cx", (d) ->
					x d.science
				).attr("cy", (d) ->
					y d.math
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

				rendering.update = (item)->
					console.log "render.update called"

				rendering.remove = ->
					$(container).remove()

				#return
				rendering

