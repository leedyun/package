# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alive_state/version'

Gem::Specification.new do |spec|
spec.name = 'alive-state'
  spec.version       = AliveState::VERSION
  spec.authors       = ["ogom"]
  spec.email         = ["ogom@hotmail.co.jp"]
  spec.summary       = %q{Alive Application State.}
  spec.description   = %q{Alive Application State on Rails.}
  spec.homepage      = "http://ogom.github.io/alive_state"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end