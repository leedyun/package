# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cards_lib/version'

Gem::Specification.new do |spec|
spec.name = 'cards-lib'
  spec.version       = CardsLib::VERSION
  spec.authors       = ["Daniel P. Clark"]
  spec.email         = ["6ftdan@gmail.com"]

  spec.summary       = 'OO Card Game Library'
  spec.description   = 'Card Game Library.  Testable and Object Oriented.'
  spec.homepage      = "http://github.com/danielpclark/CardsLib"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "color_pound_spec_reporter", "~> 0.0.5"
  spec.add_development_dependency "minitest", "~> 5.8"
  spec.add_development_dependency "minitest-reporters", "~> 1.1"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end