# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'game_shuffle_cards/version'

Gem::Specification.new do |spec|
spec.name = 'game-shuffle_cards'
  spec.version       = GameShuffleCards::VERSION
  spec.authors       = ["Diego Hernán Piccinini Lagos"]
  spec.email         = ["diego@guiasrails.es"]
  spec.summary       = "A Game to shuffle a deck of cards and presents the result"
  spec.description   = "With the class Game you can handle a deck of cards and setting the players and the cards per player. And shuffle the deak of cards."
  spec.homepage      = "https://github.com/diegopiccinini/game_shuffle_cards"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.2.0"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.has_rdoc = 'yard'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end