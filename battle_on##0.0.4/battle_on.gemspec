# -*- encoding: utf-8 -*-
require File.expand_path('../lib/battle_on/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alekx Lang"]
  gem.email         = ["alekx.lang@gmail.com"]
  gem.description   = %q{A gem that provides a simple API to ease interacting with the Platform45 API for their Battleship challenge: battle.platform45.com}
  gem.summary       = %q{A little weapon to help fight Platform45's Battleship API.}
  gem.homepage      = ""

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
gem.name = 'battle_on'
  gem.require_paths = ["lib"]
  gem.version       = BattleOn::VERSION
  gem.add_development_dependency(%q<rspec>, [">= 2.0"])
  gem.add_development_dependency(%q<webmock>, [">= 1.11.0"])
  gem.add_dependency(%q<rest-client>, [">= 1.6.7"])
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end