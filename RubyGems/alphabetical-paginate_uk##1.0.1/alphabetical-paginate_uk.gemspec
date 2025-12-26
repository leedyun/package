# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alphabetical_paginate_uk/version'

Gem::Specification.new do |spec|
spec.name = 'alphabetical-paginate_uk'
  spec.version       = AlphabeticalPaginate::VERSION
  spec.authors       = ["lingz"]
  spec.email         = ["m.antevora@gmail.com"]
  spec.description   = "Alphabetical Pagination Ukrainian"
  spec.summary       = "Pagination by letters"
  spec.homepage      = "https://github.com/refleckt/alphabetical_paginate_uk"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.6"
  spec.add_development_dependency "rails"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end