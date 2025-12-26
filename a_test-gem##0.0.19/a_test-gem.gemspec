# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a/test/gem/version'

Gem::Specification.new do |spec|
spec.name = 'a_test-gem'
  spec.version       = A::Test::Gem::VERSION
  spec.authors       = ["marano"]
  spec.email         = ["thiagomarano@gmail.com"]
  spec.summary       = %q{This is a test gem.}
  spec.description   = %q{This is the gem I am using to build snap gem release.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end