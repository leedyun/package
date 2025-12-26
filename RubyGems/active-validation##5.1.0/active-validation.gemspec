# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_validation/version'

Gem::Specification.new do |spec|
spec.name = 'active-validation'
  spec.version = ActiveValidation::VERSION
  spec.authors = ['Juan Gomez']
  spec.email = ['j.gomez@drexed.com']

  spec.summary = 'Gem for commonly used validators.'
  spec.description = 'Validate commonly used attributes easily with ActiveValidation.'
  spec.homepage = 'http://drexed.github.io/active_validation'
  spec.license = 'MIT'

  spec.files =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_runtime_dependency 'actionpack'
  spec.add_runtime_dependency 'activemodel'
  spec.add_runtime_dependency 'activesupport'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'fasterer'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'shoulda'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end