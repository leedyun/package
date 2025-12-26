# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'first_gem_rakesh/version'

Gem::Specification.new do |spec|
spec.name = 'first-gem_rakesh'
  spec.version       = FirstGemRakesh::VERSION
  spec.authors       = ["Rakesh Raut"]
  spec.email         = ["irakeshraut@gmail.com"]

  spec.summary       = %q{Test my first gem}
  spec.description   = %q{Testing my first gem}
  spec.homepage      = "https://github.com/irakeshraut/first_gem_rakesh"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end