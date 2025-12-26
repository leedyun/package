root = exports ? window

class AppliciousCore	
	DEBUG_FLAG: false
	
	constructor: () ->
		if root.DEBUG
			@setDebug true
		else
			@setDebug false
		@log "Applicious [Core] Loaded :: Debug ", @getDebug()

		
	setDebug: (flag) ->
		AppliciousCore::DEBUG_FLAG = flag

		
	getDebug: ->
		AppliciousCore::DEBUG_FLAG


	log: (debug_data...) ->
		if @getDebug()
			try
			  console.log debug_data
			catch error
			  #alert debug_data
			
# - - - #

root.AP = new AppliciousCore
root.AppliciousCore = AppliciousCore