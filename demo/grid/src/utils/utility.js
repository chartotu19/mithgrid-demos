(function() {
  MITHgrid.namespace("Utility", function(Utility) {
    return Utility.namespace("HashMap", function(HashMap) {
      return HashMap.initInstance = function(options) {
        var type, _list, _search;
        _list = [];
        type = options.type || 'index';
        _search = function(arr, val) {
          var i, _i, _ref;
          for (i = _i = 0, _ref = arr.length; _i <= _ref; i = _i += 1) {
            if (arr[i] === val) {
              return i;
            }
          }
          return false;
        };
        return {
          getHash: function(key) {
            return _search(_list, key);
          },
          getKey: function(hash) {
            if (_list[hash]) {
              return _list[hash];
            } else {
              return false;
            }
          },
          set: function(key, value) {
            if (type === 'index') {
              return _list.push(key);
            }
          }
        };
      };
    });
  });

}).call(this);
