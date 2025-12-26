require 'active_record'
if ActiveRecord::VERSION::MAJOR >= 4
elsif ActiveRecord::VERSION::MAJOR >= 3
  require 'strong_parameters'
else
  raise 'Unsupported ActiveRecord version'
end
require 'active_validator/version'
require 'active_validator/base'
