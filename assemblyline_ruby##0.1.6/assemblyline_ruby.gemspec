# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "assemblyline/ruby/version"

Gem::Specification.new do |spec|
spec.name = 'assemblyline_ruby'
  spec.version       = Assemblyline::Ruby::VERSION
  spec.authors       = ["Ed Robinson"]
  spec.email         = ["ed@reevoo.com"]

  spec.summary       = "This gem provides helpers to be used inside of Assemblyline ruby docker containers."
  spec.description   = "This gem provides helpers to be used inside of Assemblyline ruby docker containers."
  spec.homepage      = "http://www.a10e.org"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(/^exe\//) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.11"
  spec.add_development_dependency "reevoocop"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end