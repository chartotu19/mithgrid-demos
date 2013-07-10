(function() {
  var drive;

  drive = function($, container) {
    var checkAuth, downloadFile, handleAuth, printFile, scope;
    scope = ['https://www.googleapis.com/auth/drive'];
    checkAuth = function() {
      return gapi.auth.authorize({
        client_id: "948087453516.apps.googleusercontent.com",
        scope: scope,
        immediate: true
      }, handleAuth);
    };
    handleAuth = function(authResult) {
      if (authResult) {
        return gapi.client.load('drive', 'v2', printFile);
      } else {
        return gapi.auth.authorize({
          client_id: "948087453516.apps.googleusercontent.com",
          scope: scope,
          immediate: false
        }, handleAuth);
      }
    };
    /*
    	Print a file's metadata.
    	@param {String} fileId ID of the file to print metadata for.
    */

    printFile = function(fileId) {
      var request;
      fileId = fileId || $("#fileId").val();
      request = gapi.client.drive.files.get({
        fileId: fileId
      });
      return request.execute(function(resp) {
        console.log("Title: " + resp.title);
        console.log("Description: " + resp.description);
        return console.log("MIME type: " + resp.mimeType);
      });
    };
    /*
    	Download a file's content.
    
    	@param {File} file Drive File instance.
    	@param {Function} callback Function to call when the request is complete.
    */

    downloadFile = function(file, callback) {
      var accessToken, xhr;
      if (file.downloadUrl) {
        accessToken = gapi.auth.getToken().access_token;
        xhr = new XMLHttpRequest();
        xhr.open("GET", file.downloadUrl);
        xhr.setRequestHeader("Authorization", "Bearer " + accessToken);
        xhr.onload = function() {
          return callback(xhr.responseText);
        };
        xhr.onerror = function() {
          return callback(null);
        };
        return xhr.send();
      } else {
        return callback(null);
      }
    };
    console.log("gapi downloaded");
    $(container).on("click", function() {
      return checkAuth();
    });
    return $("#getFile").on("click", function() {
      return printFile();
    });
  };

}).call(this);
