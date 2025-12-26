# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'beta_invites/version'

Gem::Specification.new do |spec|
spec.name = 'beta-invites'
  spec.version       = BetaInvites::VERSION
  spec.authors       = ["Danny Kirschner"]
  spec.email         = ["rkirschner1377@gmail.com"]
  spec.description   = %q{"A beta invites gem. Useful with Devise Invitable"}
  spec.summary       = %q{"A beta invites gem"}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end