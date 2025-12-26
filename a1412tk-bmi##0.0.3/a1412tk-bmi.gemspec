# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a1412tk_bmi/version'

Gem::Specification.new do |spec|
spec.name = 'a1412tk-bmi'
  spec.version       = A1412tkBmi::VERSION
  spec.authors       = ["rivayama"]
  spec.email         = ["tomozo16@gmail.com"]
  spec.summary       = %q{Simple BMI calculation}
  spec.description   = %q{Usage: a1412tk_bmi [height(cm)] [weight(kg)]}
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