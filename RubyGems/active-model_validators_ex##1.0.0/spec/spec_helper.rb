if ENV['CODECLIMATE_REPO_TOKEN'].nil?
  require 'simplecov'
  SimpleCov.start do
    coverage_dir 'tmp/coverage'
  end
else
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'pry'
require 'active_model'
require 'active_model_validators_ex'
require 'mock_objects/mock_record'

I18n.locale     = 'pt'
I18n::load_path = Dir[File.join('./config/locales', '*.yml')]