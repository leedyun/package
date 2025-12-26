module AppliciousUtils
  module ViewHelpers

    # Creates an instance of a plupload S3 file uploader
		# Derived from https://github.com/iwasrobbed/Rails3-S3-Uploader-Plupload

    def applicious_uploader(options)
      options[:s3_config_filename] ||= Rails.root.join('config', 'amazon_s3.yml')
      config = YAML.load_file(options[:s3_config_filename])[Rails.env].symbolize_keys
      bucket            = config[:bucket_name]
      access_key_id     = config[:access_key_id]
      secret_access_key = config[:secret_access_key]

      options[:key] ||= 'uploads'  # folder on AWS to store file in
      options[:acl] ||= 'public-read'
      options[:expiration_date] ||= 10.hours.from_now.utc.iso8601
      options[:max_filesize] ||= 500.megabytes
      #options[:button_id]
			
			filename_token = SecureRandom.uuid + '_' + Time.now.to_i.to_s
			
      id = options[:id] ? "_#{options[:id]}" : ''

      policy = Base64.encode64(
        "{'expiration': '#{options[:expiration_date]}',
          'conditions': [
            {'bucket': '#{bucket}'},
            {'acl': '#{options[:acl]}'},
            {'success_action_status': '201'},
            ['content-length-range', 0, #{options[:max_filesize]}],
            ['starts-with', '$key', ''],
            ['starts-with', '$Content-Type', ''],
            ['starts-with', '$name', ''],
            ['starts-with', '$Filename', '']
          ]
        }").gsub(/\n|\r/, '')

      signature = Base64.encode64(
                    OpenSSL::HMAC.digest(
                      OpenSSL::Digest::Digest.new('sha1'),
                      secret_access_key, policy)).gsub("\n","")

      out = ""

      out << javascript_tag("$(function() {
      
        /*
         * S3 Uploader instance
        */
          	var applicious_uploader = new plupload.Uploader({
              preinit : {
                UploadFile: function(up, file) {
                  up.settings.multipart_params.key = 'uploads/#{filename_token}.' + file.name.split('.').pop();
                  up.settings.multipart_params.Filename = 'uploads/#{filename_token}.' + file.name.split('.').pop();
                }
              },
              
              
              runtimes : 'flash,silverlight',
              browse_button : '#{options[:button_id]}',
              max_file_size : '500mb',
              url : 'http://#{bucket}.s3.amazonaws.com/',
              flash_swf_url: '/applicious/plupload/plupload.flash.swf',
              silverlight_xap_url: '/applicious/plupload/plupload.silverlight.xap',
              multi_selection: false,

							//resize : {width : 320, height : 240, quality : 90},

              multipart: true,
              multipart_params: {
          			'acl': '#{options[:acl]}',
          			'Content-Type': '#{options[:content_type]}',
          			'success_action_status': '201',
          			'AWSAccessKeyId' : '#{access_key_id}',
          			'policy': '#{policy}',
          			'signature': '#{signature}'
               },
              filters : [
                  {title : '#{options[:filter_title]}', extensions : '#{options[:filter_extensions]}'}
              ],
              file_data_name: 'file'
          });
					
					AP.Uploader.init( applicious_uploader, '#{filename_token}' )
      });")
  
    end
  end
end