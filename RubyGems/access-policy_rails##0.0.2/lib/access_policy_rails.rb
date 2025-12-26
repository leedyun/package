require 'access_policy_rails/version'
require 'access_policy'
require 'active_support/concern'

module AccessPolicyRails

end

require 'access_policy_rails/request_local_storage'
require 'access_policy_rails/change_storage_scope'
require 'access_policy_rails/controller_extensions'
require 'access_policy_rails/policy_wrapper'
require 'access_policy_rails/railtie' if defined?(Rails)
