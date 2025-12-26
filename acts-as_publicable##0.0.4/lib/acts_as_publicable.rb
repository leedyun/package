require "active_record"
require "acts_as_publicable/acts_as_publicable"
require "acts_as_publicable/routes"

if defined?(ActiveRecord::Base)
    ActiveRecord::Base.send :include, ActsAsPublicable::ActiveRecordExtension
end
