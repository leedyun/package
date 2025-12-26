require 'spec_helper'

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require File.join(File.expand_path(__dir__ ),"acceptance/dummy/config/environment.rb")

#require "action_controller/railtie"
#require "action_mailer/railtie"

require 'rspec/rails'

Dir[File.join(File.expand_path(__dir__), "acceptance/support/**/*.rb")].each { |f| require f }