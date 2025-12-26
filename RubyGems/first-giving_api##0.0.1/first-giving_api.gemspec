# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'first_giving_api/version'

Gem::Specification.new do |spec|
spec.name = 'first-giving_api'
  spec.version       = FirstGivingApi::VERSION
  spec.authors       = ["Omar Shariff Delmo"]
  spec.email         = ["omaruu@gmail.com"]
  spec.description   = %q{A Ruby Wrapper for the First Giving API}
  spec.summary       = %q{First Giving API Wrapper}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  
  #include RSPEC
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency 'curb'
  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'pry'
  spec.add_runtime_dependency 'crack'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end