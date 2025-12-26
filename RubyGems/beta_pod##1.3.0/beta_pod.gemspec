# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'beta-pod/gem_version'

Gem::Specification.new do |spec|
spec.name = 'beta_pod'
  spec.version       = BetaPod::VERSION
  spec.authors       = ["Samuel Giddins"]
  spec.email         = ["segiddins@segiddins.me"]

  spec.summary       = 'A tiny gem to make running beta CocoaPods versions a breeze.'
  spec.homepage      = 'https://github.com/segiddins/beta-pod'
  spec.license       = 'MIT'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "bundler", "~> 1.10"

  spec.add_development_dependency "rake", "~> 10.4"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end