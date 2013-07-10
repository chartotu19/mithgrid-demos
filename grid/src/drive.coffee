drive = ($,container)->
	
	scope = ['https://www.googleapis.com/auth/drive']

	checkAuth = ->
		gapi.auth.authorize 
			client_id : "948087453516.apps.googleusercontent.com"
			scope : scope
			immediate : true
			, handleAuth

	handleAuth = (authResult)->
		if authResult
			#Access token
			gapi.client.load('drive', 'v2', printFile)
		else
			gapi.auth.authorize
				client_id : "948087453516.apps.googleusercontent.com"
				scope : scope
				immediate : false
				, handleAuth

	###
	Print a file's metadata.
	@param {String} fileId ID of the file to print metadata for.
	###
	printFile = (fileId) ->
		fileId = fileId || $("#fileId").val()
		request = gapi.client.drive.files.get(fileId: fileId)
		request.execute (resp) ->
	    	console.log "Title: " + resp.title
	    	console.log "Description: " + resp.description
	    	console.log "MIME type: " + resp.mimeType


	###
	Download a file's content.

	@param {File} file Drive File instance.
	@param {Function} callback Function to call when the request is complete.
	###
	downloadFile = (file, callback) ->
		if file.downloadUrl
		    accessToken = gapi.auth.getToken().access_token
		    xhr = new XMLHttpRequest()
		    xhr.open "GET", file.downloadUrl
		    xhr.setRequestHeader "Authorization", "Bearer " + accessToken
		    xhr.onload = ->
	      		callback xhr.responseText
	    	
	    	xhr.onerror = ->
	      		callback null

	    	xhr.send()
	  	else
	    	callback null

	# printFile = (fileId) ->
	# 	fileId = fileId || "1rKj0g214eksk3ukcp7GeSlkKsqIf-2OXM_U_dAf7_Fk"
	# 	request = gapi.client.drive.files.get(id: fileId)
	# 	request.execute (resp) ->
	# 		unless resp.error
	# 		  console.log "Title: " + resp.title
	# 		  console.log "Description: " + resp.description
	# 		  console.log "MIME type: " + resp.mimeType
	# 		else if resp.error.code is 401
			  
	# 		  # Access token might have expired.
	# 		  checkAuth()
	# 		else
	# 		  console.log "An error occured: " + resp.error.message

	console.log "gapi downloaded"
	# Bind the request to a call 
	$(container).on "click", ->
		checkAuth()

	$("#getFile").on "click", ->
		printFile()

