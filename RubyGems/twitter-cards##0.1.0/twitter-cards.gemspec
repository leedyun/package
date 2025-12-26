# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twitter_cards/version'

Gem::Specification.new do |spec|
spec.name = 'twitter-cards'
  spec.version       = TwitterCards::VERSION
  spec.authors       = ["Dimitris Klisiaris"]
  spec.email         = ["dklisiaris@gmail.com"]

  spec.summary       = %q{A Ruby wrapper for Twitter Cards.}
  spec.description   = %q{A very simple Ruby library for parsing Twitter Cards information from websites. See https://dev.twitter.com/cards/types for more information.}
  spec.homepage      = "https://github.com/dklisiaris/twitter_cards"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 1.9.3'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 1.8"
  spec.add_dependency "nokogiri", "~> 1.6", ">= 1.6.6"
  spec.add_dependency "hashie", "~> 3.4"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "webmock", "~> 1.21"
  
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end