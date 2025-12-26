# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'playing_cards/version'

Gem::Specification.new do |spec|
spec.name = 'rubylove-playing-cards'
  spec.version       = PlayingCards::VERSION
  spec.authors       = ["thatrubylove"]
  spec.email         = ["thatrubylove@gmail.com"]
  spec.description   = %q{A playing card library in functiona ruby}
  spec.summary       = %q{Functional Ruby Playing Cards}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end