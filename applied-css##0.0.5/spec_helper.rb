require File.expand_path(File.dirname(__FILE__) + '/../lib/applied_css')
require "fakeweb"

FakeWeb.allow_net_connect = false

puts "spec_helper"

RSpec.configure do |config|
  config.before(:each) do
    FakeWeb.clean_registry
  end
end