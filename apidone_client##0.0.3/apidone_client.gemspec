# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apidone-client/version'

Gem::Specification.new do |gem|
gem.name = 'apidone_client'
  gem.version       = Apidone::Client::VERSION
  gem.authors       = ["Miguel Michelson", "Luis Mancilla", "Daniel Guajardo", "Daniel Gutiérrez", "Magno Cardona"]
  gem.email         = ["miguelmichelson@gmail.com"]
  gem.description   = "Apidone.com ruby api client"
  gem.summary       = "Apidone ruby client is a simple client for apidone.com, this library was made in the context of coding (ruby) dojo. oct 2012"
  gem.homepage      = "http://apidone.com"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_runtime_dependency("thor")
  gem.add_runtime_dependency("faraday")
  gem.add_runtime_dependency("json")
  
  gem.add_development_dependency(%q<bundler>)
  gem.add_development_dependency(%q<rspec>,           ["~> 2.6.0"])
  
  
  
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end