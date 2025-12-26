module AppliciousUtils
  require 'applicious_utils/engine'
  require 'applicious_utils/version'
  require 'applicious_utils/view_helpers'
  ActionView::Base.send :include, ViewHelpers
  
end
=begin
module AppliciousUtils
#config.autoload_paths += %W(#{config.root}/app/middlewares)
#ActionController::Dispatcher.middleware.insert_before(ActionController::Base.session_store, FlashSessionCookieMiddleware, ActionController::Base.session_options[:key])
#Rails.application.config.middleware.insert_before(Rails.application.config.session_store, FlashSessionCookieMiddleware, Rails.application.config.session_options[:key])
#require 'applicious_utils/engine'
end
=end