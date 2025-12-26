# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_redis_stats/version'

Gem::Specification.new do |spec|
spec.name = 'active-redis_stats'
  spec.version = ActiveRedisStats::VERSION
  spec.authors = ['Juan Gomez']
  spec.email = ['j.gomez@drexed.com']

  spec.summary = 'Gem for Redis based analytics.'
  spec.description = 'Redis based analytics.'
  spec.homepage = 'http://drexed.github.io/active_redis_stats'
  spec.license = 'MIT'

  spec.files =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_runtime_dependency 'active_object'
  spec.add_runtime_dependency 'active_redis_db'
  spec.add_runtime_dependency 'activesupport'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'fakeredis'
  spec.add_development_dependency 'fasterer'
  spec.add_development_dependency 'generator_spec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end