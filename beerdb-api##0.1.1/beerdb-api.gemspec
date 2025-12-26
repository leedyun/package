# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'beerdb_api/version'

Gem::Specification.new do |spec|
spec.name = 'beerdb-api'
  spec.version       = BeerdbApi::VERSION
  spec.authors       = ["Blake Yoder"]
  spec.email         = ["yoderblake@gmail.com"]
  spec.summary       = %q{Simple wrapper for the BreweryDB API}
  spec.homepage      = "https://github.com/blakeyoder/beerdb_api"
  spec.license       = "MIT"


  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"
  spec.add_dependency "json"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end