# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_subset_validator/version'

Gem::Specification.new do |spec|
spec.name = 'active-subset-validator'
  spec.version       = ActiveSubsetValidator::VERSION
  spec.authors       = ["Paul Sorensen"]
  spec.email         = ["paulnsorensen@gmail.com"]
  spec.description   = %q{Provides subset validation for serialized arrays or sets in Active Record}
  spec.summary       = %q{Checks whether given values for a serialized array or set are a subset of a given array, set or proc against which to validate}
  spec.homepage      = "https://github.com/paulnsorensen/active_subset_validator"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "sqlite3"
  spec.add_runtime_dependency 'activemodel', '>= 3'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end