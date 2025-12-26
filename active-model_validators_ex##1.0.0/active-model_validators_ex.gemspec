# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_model_validators_ex/version'

Gem::Specification.new do |spec|
spec.name = 'active-model_validators_ex'
  spec.version       = ActiveModelValidatorsEx::VERSION
  spec.authors       = ["junhanamaki"]
  spec.email         = ["jun.hanamaki@gmail.com"]
  spec.summary       = %q{Custom validators for ActiveModel}
  spec.description   = %q{Add more validators for your ActiveModel models.}
  spec.homepage      = "https://github.com/junhanamaki/active_model_validators_ex"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.9'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  spec.add_development_dependency 'jazz_hands', '~> 0.5'
  spec.add_development_dependency 'activemodel', '~> 4.1'
  spec.add_development_dependency 'mongoid', '~> 4.0'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end