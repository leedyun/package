require "rspec"
require "rspec/its"
require "webmock/rspec"

begin
  require "pry"
rescue LoadError
  nil
end

Bundler.require

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.profile_examples = 10
  config.order = :random

  Kernel.srand config.seed
end
