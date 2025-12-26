ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __FILE__)

require "rubygems"
require "bundler"
Bundler.setup(:default, :test)

$:.unshift(File.expand_path("../../lib", __FILE__))

require "rspec/core"
require "rspec/its"

require "bosh/plugin_generator"

def asset_file(*path)
  assets_file = File.expand_path("../assets", __FILE__)
  File.join(assets_file, *path)
end
