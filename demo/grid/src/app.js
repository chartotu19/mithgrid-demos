(function() {
  var __slice = [].slice;

  MITHgrid.Application.namespace("gridDemo", function(exp) {
    return exp.initInstance = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref = MITHgrid.Application).initInstance.apply(_ref, ["MITHgrid.Application.gridDemo"].concat(__slice.call(args), [function(that, container) {
        return that.ready(function() {
          console.log(that.dataView.csvData.items());
          that.dataStore.csv.loadItems({
            id: "csv1",
            type: "number",
            name: "selvam",
            age: 21,
            score: 50
          });
          console.log(that.dataView.csvData.items());
          that.dataStore.csv.getItem("csv1", function(d) {
            return console.log(d);
          });
          console.log(that);
          return console.log("ready");
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
        type: ["number"]
      }
    },
    presentations: {
      opTable: {
        type: MITHgrid.Presentation.Table,
        container: "#opTable",
        dataView: "csvData",
        columns: [1, 2, 3],
        columnLabels: ["name", "age", "score"]
      }
    }
  });

}).call(this);
