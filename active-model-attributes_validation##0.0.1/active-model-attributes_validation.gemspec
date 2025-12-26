# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_model/attributes_validation/version'

Gem::Specification.new do |spec|
spec.name = 'active-model-attributes_validation'
  spec.version       = ActiveModel::AttributesValidation::VERSION
  spec.authors       = ["dm1try"]
  spec.email         = ["me@dmitry.it"]
  spec.description   = %q{Validates a specific attribute on ActiveModel, ActiveRecord}
  spec.summary       = %q{Validates a specific attribute on ActiveModel, ActiveRecord}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", ">= 3.2"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end