require "minitest/autorun"
$: << File.expand_path('../../lib', __FILE__)
require "application_module"
require "rails"

$dummy_path = File.expand_path("../../spec/dummies/dummy-rails-#{Rails.version}",  __FILE__)

ENV["RAILS_ENV"] ||= "test"
require "#{$dummy_path}/config/environment.rb"
require 'animals'

require 'rails/test_help'
