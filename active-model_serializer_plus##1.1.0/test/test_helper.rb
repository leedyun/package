ENV['RAILS_ENV'] ||= 'test'

##
# Load Rails dummy application based on gemfile name substituted by Appraisal
#
if ENV["APPRAISAL_INITIALIZED"] || ENV["TRAVIS"]
    app_name = Pathname.new(ENV['BUNDLE_GEMFILE']).basename.sub('.gemfile', '')
else
    app_name = 'rails_4.2'
end

require File.expand_path("../../test/app/#{app_name}/config/environment", __FILE__)
APP_RAKEFILE = File.expand_path("../../test/app/#{app_name}/Rakefile", __FILE__)

require 'rails/test_help'

class ActiveSupport::TestCase

    # Add more helper methods to be used by all tests here...

end
