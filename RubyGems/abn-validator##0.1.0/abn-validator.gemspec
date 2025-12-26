# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'abn_validator/version'

Gem::Specification.new do |spec|
spec.name = 'abn-validator'
  spec.version       = AbnValidator::VERSION
  spec.authors       = ['Rob McFadzean']
  spec.email         = ['root@sphericalcube.net']
  spec.summary       = %q{Rails validator for ABNs}
  spec.description   = %q{Rails validator for Australian Business Numbers}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'

  spec.add_runtime_dependency 'activemodel'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end