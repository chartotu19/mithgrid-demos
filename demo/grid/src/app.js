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
          var binding, opTable, test;
          opTable = MITHgrid.Presentation.Table.initInstance('.opTable', {
            columns: ["userName", "userAge", "math", "science"],
            columnLabels: {
              userName: "First Name",
              userAge: "Age",
              math: "Mathematics",
              science: "Science"
            },
            dataView: that.dataView.csvData
          });
          that.dataStore.csv.events.onModelChange.addListener(function() {
            return console.log("model updated");
          });
          test = that.dataStore.csv.loadItems([test]);
          window["test"] = that;
          binding = MITHgrid.Click.initInstance({}).bind("#defUpload");
          return binding.events.onSelect.addListener(function() {
            var cb;
            cb = function(data) {
              console.log("success");
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
        columns: [1, 2, 3, 4],
        columnLabels: ["name", "age", "math", "science"]
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
