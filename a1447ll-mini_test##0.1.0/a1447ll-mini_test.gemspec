# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a1447ll_mini_test/version'

Gem::Specification.new do |spec|
spec.name = 'a1447ll-mini_test'
  spec.version       = A1447llMiniTest::VERSION
  spec.authors       = ["Le Bao Linh"]
  spec.email         = ["a1447ll@aiit.ac.jp"]
  spec.summary       = "Minitest practice" 
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end