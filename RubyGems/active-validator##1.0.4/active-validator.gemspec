# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_validator/version'

Gem::Specification.new do |spec|
spec.name = 'active-validator'
  spec.version       = ActiveValidator::VERSION
  spec.authors       = ["Nathan Pearson"]
  spec.email         = ["npearson72@gmail.com"]
  spec.description   = "Create Rails active record style validation in your non-Rails app"
  spec.summary       = "Lightweight client app validators"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "activerecord"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "strong_parameters"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end