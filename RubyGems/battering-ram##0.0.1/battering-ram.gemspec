# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'battering_ram/version'

Gem::Specification.new do |spec|
spec.name = 'battering-ram'
  spec.version       = BatteringRam::VERSION
  spec.authors       = ["kristenmills"]
  spec.email         = ["kristen@kristen-mills.com"]
  spec.description   = %q{Fuzz testing for ruby}
  spec.summary       = %q{Fuzz testing for ruby}
  spec.homepage      = "https://github.com/kristenmills/battering_ram"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end