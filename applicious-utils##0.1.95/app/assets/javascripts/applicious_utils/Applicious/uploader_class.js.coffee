#= require ./applicious_class.js.coffee
root = exports ? window

class AppliciousUploader extends AppliciousCore
	@UploadObj: ''
	@FileToken: ''


	constructor: ->
		@log 'Applicious [AP::Uploader] Loaded'


	init: (@UploadObj, @FileToken) ->
		@UploadObj.init()
		
		@UploadObj.bind 'FilesAdded', (up, files) =>			
			@log 'FilesAdded:', up, files
			root.appliciousUploaderFileAdded up, files

		@UploadObj.bind 'UploadProgress', (up, file) =>
			#@log 'UploadProgress:', up, file
			root.appliciousUploaderUploadProgress up, file

		@UploadObj.bind 'FileUploaded', (up, file) =>
			token = up.settings.multipart_params.key
			@log 'FileUploaded:', up, file, token
			root.appliciousUploaderFileUploaded up, file, token

		@UploadObj.bind 'Error', (up, error) =>
			@log 'Error:', up, error
			root.appliciousUploaderError up, error

		@log 'Initialised [AP::Uploader]', @UploadObj

# - - - #

AP.Uploader = new AppliciousUploader