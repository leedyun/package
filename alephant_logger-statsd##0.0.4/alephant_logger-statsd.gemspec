# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alephant/logger/statsd/version'

Gem::Specification.new do |spec|
spec.name = 'alephant_logger-statsd'
  spec.version       = Alephant::Logger::Statsd::VERSION
  spec.authors       = ["BBC News"]
  spec.email         = ["FutureMediaNewsRubyGems@bbc.co.uk"]
  spec.summary       = %q{StatsD driver for Alephant Logger gem.}
  spec.homepage      = "https://github.com/BBC-News/alephant-logger-statsd"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "statsd-ruby"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "rake-rspec"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end