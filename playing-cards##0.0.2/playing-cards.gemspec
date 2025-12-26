# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'playing_cards/version'

Gem::Specification.new do |gem|
gem.name = 'playing-cards'
  gem.version       = PlayingCards::VERSION
  gem.authors       = ["hollanddd"]
  gem.email         = ["me@darrenholland.com"]
  gem.description   = %q{Standard deck of 52. No Jokers}
  gem.summary       = %q{Standard deck of 52. No Jokers}
  gem.homepage      = "https://github.com/hollanddd/playing_cards"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end