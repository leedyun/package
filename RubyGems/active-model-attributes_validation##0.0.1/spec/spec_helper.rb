$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'active_model/attributes_validation'

require 'rubygems'
require 'bundler'
Bundler.setup :default, :test
I18n.enforce_available_locales = false
