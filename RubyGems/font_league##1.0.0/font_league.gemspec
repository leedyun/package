# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'font-league/version'

Gem::Specification.new do |spec|
spec.name = 'font_league'
  spec.version       = FontLeague::Rails::VERSION
  spec.authors       = ["Ty Rauber"]
  spec.email         = ["tyrauber@mac.com"]
  spec.description   = "FontLeague - 'The League of Moveable Type' Web Fonts"
  spec.summary       = "An unofficial collection of 'The League of Moveable Type' fonts bundled as a web font ruby gem."
  spec.homepage      = "https://www.theleagueofmoveabletype.com"
  spec.license       = "OFL"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "railties", ">= 3.2", "< 5.0"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "sass-rails"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end