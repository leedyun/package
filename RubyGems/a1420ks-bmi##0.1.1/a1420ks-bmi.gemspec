# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a1420ks_bmi/version'

Gem::Specification.new do |spec|
spec.name = 'a1420ks-bmi'
  spec.version       = A1420ksBmi::VERSION
  spec.authors       = ["k-shimomura"]
  spec.email         = ["s.kensuke@gmail.com"]

  spec.summary       = %q{calc BMI.}
  spec.description   = %q{.}
  spec.homepage      = ""


  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end