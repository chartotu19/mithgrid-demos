(function() {
  var __slice = [].slice;

  MITHgrid.Application.namespace("gridDemo", function(exp) {
    return exp.initInstance = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref = MITHgrid.Application).initInstance.apply(_ref, ["MITHgrid.Application.gridDemo"].concat(__slice.call(args), [function(that, container) {
        return that.ready(function() {
          var test;
          test = {
            id: "csv1",
            type: "number",
            columns: [1, 2, 3],
            columnLabels: ["name", "age", "score"]
          };
          that.dataStore.csv.loadItems([test]);
          window["test"] = that;
          return console.log(that.dataView.csvData.items());
        });
      }]));
    };
  });

  MITHgrid.defaults("MITHgrid.Application.gridDemo", {
    dataStores: {
      csv: {
        types: {
          number: {}
        }
      }
    },
    dataViews: {
      csvData: {
        dataStore: "csv",
        type: ["number"],
        events: {
          onModelChange: function(e) {
            return console.log("CHANGE");
          }
        }
      }
    },
    presentations: {
      opTable: {
        type: MITHgrid.Presentation.Table,
        container: ".opTable",
        dataView: "csvData",
        columns: [1, 2, 3],
        columnLabels: ["name", "age", "score"]
      }
    }
  });

}).call(this);
