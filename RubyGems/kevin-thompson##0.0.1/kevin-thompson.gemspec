# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kevin_thompson/version'

Gem::Specification.new do |spec|
spec.name = 'kevin-thompson'
  spec.version       = KevinThompson::VERSION
  spec.authors       = ["Kevin Thompson"]
  spec.email         = ["kevin@kevinthompson.info"]
  spec.description   = %q{A gem used to find information about Kevin Thompson}
  spec.summary       = %q{Kevin Thompson's Information}
  spec.homepage      = "http://kevinthompson.info"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end