(function() {
  var __slice = [].slice;

  MITHgrid.Application.namespace("gridDemo", function(exp) {
    return exp.initInstance = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref = MITHgrid.Application).initInstance.apply(_ref, ["MITHgrid.Application.gridDemo"].concat(__slice.call(args), [function(that, container) {
        return that.ready(function() {
          var opTable, test;
          opTable = MITHgrid.Presentation.Table.initInstance('.opTable', {
            columns: ["userName", "userAge", "score"],
            columnLabels: {
              userName: "User",
              userAge: "Age",
              score: "Score"
            },
            dataView: that.dataView.csvData
          });
          that.dataStore.csv.events.onModelChange.addListener(function() {
            return console.log("model updated");
          });
          test = {
            id: "csv1",
            type: "number",
            columns: ["userName", "userAge", "score"],
            userName: "Foo",
            userAge: 21,
            score: 99
          };
          that.dataStore.csv.loadItems([test]);
          return window["test"] = that;
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
        container: ".opTable",
        dataView: "csvData",
        columns: [1, 2, 3],
        columnLabels: ["name", "age", "score"]
      }
    }
  });

}).call(this);
