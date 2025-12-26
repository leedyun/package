# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a_stupid_test_gem/version'

Gem::Specification.new do |spec|
spec.name = 'a-stupid-test_gem'
  spec.version       = AStupidTestGem::VERSION
  spec.authors       = ["Mark Lorenz"]
  spec.email         = ["mlorenz@covermymeds.com"]
  spec.summary       = %q{a stupid test that i'm going to delete}
  spec.description   = %q{well, I guess the description is not really optional}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end