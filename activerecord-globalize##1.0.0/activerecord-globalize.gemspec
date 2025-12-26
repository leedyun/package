# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord_globalize/version'

Gem::Specification.new do |spec|
spec.name = 'activerecord-globalize'
  spec.version       = ActiverecordGlobalize::VERSION
  spec.authors       = ['mohamedelfiky']
  spec.email         = ['mohamed.elfikyy@gmail.com']

  spec.summary       = "Adds model translations allow you to translate your models' attributes"
  spec.homepage      = 'https://github.com/mohamedelfiky/activerecord_globalize'
  spec.license       = 'MIT'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'appraisal'

  spec.add_dependency 'activerecord', '>= 4.0.0'
  spec.add_dependency 'railties', '>= 4.0.0'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end