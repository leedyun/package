# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a1436mm_age/version'

Gem::Specification.new do |spec|
spec.name = 'a1436mm-age'
  spec.version       = A1436mmAge::VERSION
  spec.authors       = ["a1436mm"]
  spec.email         = ["a1436mm@aiit.ac.jp"]
  spec.summary       = %q{Compute your age}
  spec.description   = %q{Please give Your BirthYear}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end