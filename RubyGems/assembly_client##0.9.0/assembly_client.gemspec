# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'assembly/version'

Gem::Specification.new do |spec|
spec.name = 'assembly_client'
  spec.version       = Assembly::VERSION
  spec.authors       = ["Assembly Education"]
  spec.email         = ["developers@assembly.education"]

  spec.summary       = %q{Ruby client library for the Assembly Platform}
  spec.homepage      = "http://platform.assembly.education"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday",            "~> 0.12.2"
  spec.add_dependency "faraday_middleware", "~> 0.12.2"

  spec.add_development_dependency "bundler",            "~> 1.15"
  spec.add_development_dependency "rake",               "~> 12.1"
  spec.add_development_dependency "mocha",              "~> 1.3"
  spec.add_development_dependency "webmock",            "~> 3.0"
  spec.add_development_dependency "guard",              "~> 2.14"
  spec.add_development_dependency "guard-minitest",     "~> 2.4"
  spec.add_development_dependency "minitest-reporters", "~> 1.1"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end