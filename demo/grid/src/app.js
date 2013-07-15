(function() {
  var __slice = [].slice;

  MITHgrid.namespace("Click", function(that) {
    return that.initInstance = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref = MITHgrid.Controller).initInstance.apply(_ref, ["MITHgrid.Click"].concat(__slice.call(args), [function(that) {
        return that.applyBindings = function(binding) {
          return binding.locate('').click(binding.events.onSelect.fire);
        };
      }]));
    };
  });

  MITHgrid.Application.namespace("gridDemo", function(exp) {
    return exp.initInstance = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref = MITHgrid.Application).initInstance.apply(_ref, ["MITHgrid.Application.gridDemo"].concat(__slice.call(args), [function(that, container) {
        return that.ready(function() {
          var binding, opTable;
          opTable = MITHgrid.Presentation.Table.initInstance('.opTable', {
            columns: ["name", "age", "math", "science"],
            columnLabels: {
              name: "First Name",
              age: "Age",
              math: "Mathematics",
              science: "Science"
            },
            dataView: that.dataView.csvData
          });
          MITHgrid.Presentation.Graph.initInstance(".plot", {
            dataView: that.dataView.csvData
          });
          exp = that.dataStore.csv.prepare(["!userName"]);
          that.dataStore.csv.events.onModelChange.addListener(function() {
            return console.log("model updated");
          });
          window["test"] = that;
          binding = MITHgrid.Click.initInstance({}).bind("#defUpload");
          return binding.events.onSelect.addListener(function() {
            var cb;
            cb = function(data) {
              if (data != null) {
                return that.dataStore.csv.loadItems(data.entries);
              }
            };
            return $.ajax({
              url: "data.json",
              type: "get",
              success: cb
            });
          });
        });
      }]));
    };
  });

  MITHgrid.defaults("MITHgrid.Application.gridDemo", {
    dataStores: {
      csv: {
        types: {
          student: {},
          record: {}
        },
        properties: {
          "name": {
            valueType: "item"
          }
        }
      }
    },
    dataViews: {
      csvData: {
        dataStore: "csv",
        type: ["record", "student"]
      }
    }
  });

  MITHgrid.defaults("MITHgrid.Click", {
    bind: {
      events: {
        onSelect: null
      }
    }
  });

}).call(this);
