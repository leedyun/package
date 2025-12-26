require 'bundler/setup'
Bundler.setup


require 'aligned_table'


RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
