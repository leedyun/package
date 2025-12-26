# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stuck_it_up/version'

Gem::Specification.new do |spec|
spec.name = 'stuck-it_up'
  spec.version       = StuckItUp::VERSION
  spec.authors       = ["jsquire4"]
  spec.email         = ["jacobmsquire@yahoo.com"]

  spec.summary       = %q{Demo for building gems}
  spec.homepage      = "https://github.com/jsquire4/stuck_it_up"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end