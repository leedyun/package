# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'anything/slider/version'

Gem::Specification.new do |spec|
spec.name = 'anything_slider'
  spec.version       = Anything::Slider::VERSION
  spec.authors       = ["Oscar Hugo Cardenas Lopez"]
  spec.email         = ["ohcl87@hotmail.com"]
  spec.description   = %q{This is a personal gem to add anything slider efect in rails application}
  spec.summary       = %q{provide a rails genetator and easy to configure}
  spec.homepage      = "https://github.com/sorsucrel/anything-slider"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "haml"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end