# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adapter/sqlite3/version'

Gem::Specification.new do |spec|
spec.name = 'adapter_sqlite3'
  spec.version       = Adapter::Sqlite3::VERSION
  spec.authors       = ["Luke Chadwick"]
  spec.email         = ["me@vertis.io"]
  spec.description   = %q{Add sqlite3 support to adapter}
  spec.summary       = %q{Add sqlite3 support to adapter}
  spec.homepage      = "https://github.com/vertis/adapter-sqlite3"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  
  spec.add_dependency "adapter", "~> 0.7.0"
  spec.add_dependency "sqlite3", "~> 1.3.8"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end