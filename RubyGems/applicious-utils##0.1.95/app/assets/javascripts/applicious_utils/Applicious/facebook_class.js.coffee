#= require ./applicious_class.js.coffee
	
class AppliciousFacebook extends AppliciousCore
	@FB_APP_ID: ''
	@FB_UID: ''
	@FB_RESPONSE: ''
	@FB_STATUS: ''
	@FB_ACCESS_TOKEN

	constructor: ->
		@log 'Applicious [AP::FB] Loaded'
	
		
	init: (@FB_APP_ID) ->
		@log 'Initialised [AP::FB]', @FB_APP_ID
	
	login: (permissions = '', callback) ->
		responseHandler = (response) =>
				
			if response.authResponse
				try
					@FB_STATUS = response.status
					@FB_RESPONSE = response.authResponse
					@FB_UID = response.authResponse.userID
					@FB_ACCESS_TOKEN = response.authResponse.accessToken
				catch error
					@log 'Error', error
									
				@log 'Login accepted - No Permissions', response
				callback true, response					

			else
				@log 'Login rejected', response
				callback false, response
			return

		FB.login responseHandler, scope: permissions
		return
		
# - - - #

AP.FB = new AppliciousFacebook