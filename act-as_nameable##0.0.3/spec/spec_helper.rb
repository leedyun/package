require 'rspec'
require 'act_as_nameable'

root = ActAsNameable.root
Dir[root.join('spec/support/*.rb')].each {|f| require f}

RSpec.configure do |config|
  config.color_enabled = true
  config.mock_with :rspec
  config.order = 'random'
end
