require 'rails/generators'

class AppliciousUploaderGenerator < Rails::Generators::Base
  def self.source_root
    @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end
  
  def create_uploader_files
    template "amazon_s3.yml", "#{Rails.root}/config/amazon_s3.yml"
    copy_file  "../../../app/assets/javascripts/applicious_utils/Plupload/js/plupload.flash.swf", "public/applicious/plupload/plupload.flash.swf"
    copy_file  "../../../app/assets/javascripts/applicious_utils/Plupload/js/plupload.silverlight.xap", "public/applicious/plupload/plupload.silverlight.xap"    
    copy_file  "applicious_uploader.js.coffee", "app/assets/javascripts/applicious_uploader.js.coffee"    
    copy_file  "crossdomain.xml", "public/applicious/UPLOAD_TO_S3/crossdomain.xml"
    copy_file  "clientaccesspolicy.xml", "public/applicious/UPLOAD_TO_S3/clientaccesspolicy.xml"
  end
end