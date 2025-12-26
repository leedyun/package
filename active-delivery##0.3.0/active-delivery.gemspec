# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_delivery/version"

Gem::Specification.new do |spec|
spec.name = 'active-delivery'
  spec.version       = ActiveDelivery::VERSION
  spec.authors       = ["Vladimir Dementyev"]
  spec.email         = ["dementiev.vm@gmail.com"]

  spec.summary       = "Rails framework for managing all types of notifications in one place"
  spec.description   = "Rails framework for managing all types of notifications in one place"
  spec.homepage      = "https://github.com/palkan/active_delivery"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.4"

  spec.metadata = {
    "bug_tracker_uri" => "http://github.com/palkan/active_delivery/issues",
    "changelog_uri" => "https://github.com/palkan/active_delivery/blob/master/CHANGELOG.md",
    "documentation_uri" => "http://github.com/palkan/active_delivery",
    "homepage_uri" => "http://github.com/palkan/active_delivery",
    "source_code_uri" => "http://github.com/palkan/active_delivery"
  }

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard", "~> 0.0.12"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end