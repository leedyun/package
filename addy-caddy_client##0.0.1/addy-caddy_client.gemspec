# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'addy_caddy_client/version'

Gem::Specification.new do |spec|
spec.name = 'addy-caddy_client'
  spec.version       = AddyCaddyClient::VERSION
  spec.authors       = ["Jim Sutton"]
  spec.email         = ["jimsuttonjimsutton@gmail.com"]
  spec.summary       = "Provides a wrapper for making queries to apis and local data."
  spec.homepage      = "http://192.241.133.37"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.1"
  
  spec.add_dependency 'devise', "~> 3.4"
  spec.add_dependency 'omniauth', "~> 1.2"
  spec.add_dependency 'omniauth-twitter', "~> 1.1" 
  spec.add_dependency 'figaro', "~> 1.0"
  spec.add_dependency 'geocoder', "~> 1.2"
  spec.add_dependency 'httparty', "~> 0.13"

  

spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end