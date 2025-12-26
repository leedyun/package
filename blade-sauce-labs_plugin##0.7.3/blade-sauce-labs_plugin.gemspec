# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blade/sauce_labs_plugin/version'

Gem::Specification.new do |spec|
spec.name = 'blade-sauce-labs_plugin'
  spec.version       = Blade::SauceLabsPlugin::VERSION
  spec.authors       = ["Javan Makhmali"]
  spec.email         = ["javan@javan.us"]

  spec.summary       = %q{Blade Runner plugin for Sauce Labs (saucelabs.com)}
  spec.homepage      = "https://github.com/javan/blade-sauce_labs_plugin"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "blade", ">= 0.5.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "webmock", "~> 1.21.0"

  spec.add_dependency "selenium-webdriver"
  spec.add_dependency "faraday"
  spec.add_dependency "childprocess"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end