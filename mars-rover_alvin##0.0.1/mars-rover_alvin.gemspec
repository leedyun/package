# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mars_rover_alvin/version'

Gem::Specification.new do |spec|
spec.name = 'mars-rover_alvin'
  spec.version       = '0.0.1'
  spec.authors       = ["Alvin Kato J.R."]
  spec.email         = ["alvinkatojr@gmail.com"]
  spec.summary       = %q{A mars rover gem}
  spec.description   = %q{Create rovers using this gem and solve the mars-rover challenge}
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