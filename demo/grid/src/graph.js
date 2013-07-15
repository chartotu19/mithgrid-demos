(function() {
  var __slice = [].slice;

  MITHgrid.Presentation.namespace("Graph", function(Graph) {
    return Graph.initInstance = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref = MITHgrid.Presentation).initInstance.apply(_ref, ["MITHgrid.Presentation.Graph"].concat(__slice.call(args), [function(that, container) {
        var options;
        options = that.options;
        that.hasLensFor = function() {
          return true;
        };
        $(container).append("<svg></svg>");
        console.log("Graph initInstance");
        return that.render = function(container, model, id) {
          var color, d, data, dots, height, i, items, legend, margin, mouseOff, mouseOn, rendering, svg, width, x, xAxis, y, yAxis;
          rendering = {};
          console.log("graph render called");
          d3.select(container).select("svg").remove();
          margin = {
            top: 20,
            right: 20,
            bottom: 30,
            left: 40
          };
          width = 960 - margin.left - margin.right;
          height = 500 - margin.top - margin.bottom;
          x = d3.scale.linear().range([0, width]);
          y = d3.scale.linear().range([height, 0]);
          color = d3.scale.category10();
          xAxis = d3.svg.axis().scale(x).orient("bottom");
          yAxis = d3.svg.axis().scale(y).orient("left");
          svg = d3.select(container).append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
          items = model.items();
          i = 0;
          data = [];
          while (i < items.length) {
            d = {};
            d.science = model.getItem(items[i]).science;
            d.math = model.getItem(items[i]).math;
            d.name = model.getItem(items[i]).name;
            data.push(d);
            i++;
          }
          x.domain(d3.extent(data, function(d) {
            return d.science;
          })).nice();
          y.domain(d3.extent(data, function(d) {
            return d.math;
          })).nice();
          svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call(xAxis).append("text").attr("class", "label").attr("x", width).attr("y", -6).style("text-anchor", "end").text("science");
          svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("class", "label").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text("Math");
          svg.selectAll(".dot").data(data).enter().append("circle").attr("class", "dot").attr("r", 6).style("opacity", 0.5).attr("cx", function(d) {
            return x(d.science);
          }).attr("cy", function(d) {
            return y(d.math);
          }).style("fill", function(d) {
            return color(d.name);
          });
          legend = svg.selectAll(".legend").data(color.domain()).enter().append("g").attr("class", "legend").attr("transform", function(d, i) {
            return "translate(0," + i * 20 + ")";
          });
          legend.append("rect").attr("x", width - 18).attr("width", 18).attr("height", 18).style("fill", color);
          legend.append("text").attr("x", width - 24).attr("y", 9).attr("dy", ".35em").style("text-anchor", "end").text(function(d) {
            return d;
          });
          dots = svg.selectAll(".dot");
          mouseOn = function() {
            var dot;
            dot = d3.select(this);
            dot.transition().duration(800).style("opacity", 1).attr("r", 12).ease("elastic");
            svg.append("g").attr("class", "guide").append("line").attr("x1", dot.attr("cx")).attr("x2", dot.attr("cx")).attr("y1", +dot.attr("cy") + 16).attr("y2", height).style("stroke", dot.style("fill")).transition().delay(200).duration(400);
            return svg.append("g").attr("class", "guide").append("line").attr("x1", +dot.attr("cx") - 16).attr("x2", 0).attr("y1", dot.attr("cy")).attr("y2", dot.attr("cy")).style("stroke", dot.style("fill")).transition().delay(200).duration(400);
          };
          mouseOff = function() {
            d3.select(this).transition().duration(800).style("opacity", .5).attr("r", 6).ease("elastic");
            return d3.selectAll(".guide").transition().duration(100).styleTween("opacity", function() {
              return d3.interpolate(.5, 0);
            }).remove();
          };
          dots.on("mouseover", mouseOn);
          dots.on("mouseout", mouseOff);
          rendering.update = function(item) {
            return console.log("render.update called");
          };
          rendering.remove = function() {
            return $(container).remove();
          };
          return rendering;
        };
      }]));
    };
  });

}).call(this);
