# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a1539kh_calculator/version'

Gem::Specification.new do |spec|
spec.name = 'a1539kh-calculator'
  spec.version       = A1539khCalculator::VERSION
  spec.authors       = ["HARA Koji"]
  spec.email         = ["a1539kh@aiit.ac.jp"]

  spec.summary       = %q{fizz-buzz calculator}
  spec.description   = %q{This is fizz-buzz calculator.}
  spec.homepage      = "https://rubygems.org/profiles/harakoji"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "fizz-buzz", "~> 0.5"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end