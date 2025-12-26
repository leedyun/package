# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'agnostic/duplicate/version'

Gem::Specification.new do |spec|
spec.name = 'agnostic_duplicate'
  spec.version       = Agnostic::Duplicate::VERSION
  spec.authors       = ['David Saenz Tagarro']
  spec.email         = ['david.saenz.tagarro@gmail.com']
  spec.summary       = <<-summary
Duplicate library provides additional support for deep copy or shallow copy of
specific fields in your models while you are `dupping` an instance.)
summary
  spec.description   = <<-desc
The advantage of using Duplicate module reside in support for fields that
are not duplicated by default for any reason by calling `dup`.)
desc
  spec.homepage      = 'https://github.com/dsaenztagarro/agnostic-duplicate'
  spec.license       = 'MIT'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'cane'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end