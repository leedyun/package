# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a1510jy_bmi/version'

Gem::Specification.new do |spec|
spec.name = 'a1510jy-bmi'
  spec.version       = A1510jyBmi::VERSION
  spec.authors       = ["a1510jy"]
  spec.email         = ["a1510jy@aiit.ac.jp"]

  spec.summary       = %q{Body Mass Index Class}
  spec.homepage      = "https://github.com/a1510jy/a1510jy_bmi.git"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end