# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hello_kelvinst/version'

Gem::Specification.new do |spec|
spec.name = 'hello-kelvinst'
  spec.version       = HelloKelvinst::VERSION
  spec.authors       = ["kelvinst"]
  spec.email         = ["kelvin.stinghen@gmail.com"]
  spec.summary       = "A hello gem to the ruby world"
  spec.description   = "I just created this gem to say hello for the ruby gems world, okay."
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