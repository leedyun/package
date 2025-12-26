# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hack_cards/version'

Gem::Specification.new do |spec|
spec.name = 'hack-cards'
  spec.version       = HackCards::VERSION
  spec.authors       = ["MichaelByrd"]
  spec.email         = ["michaelbyrdsemail@gmail.com"]
  spec.summary       = %q{A gem to help create media cards.}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/michaelbyrd/hack_cards"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end