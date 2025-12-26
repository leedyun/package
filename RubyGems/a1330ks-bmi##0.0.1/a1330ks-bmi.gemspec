# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a1330ks_bmi/version'

Gem::Specification.new do |spec|
spec.name = 'a1330ks-bmi'
  spec.version       = A1330ksBmi::VERSION
  spec.authors       = ["Kei SAKAMOTO"]
  spec.email         = ["a1330ks@aiit.ac.jp"]
  spec.summary       = %q{Calculating BMI.}
  spec.description   = %q{Calculating BMI from input by keyboard. And a index judged using a calculation result.}
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