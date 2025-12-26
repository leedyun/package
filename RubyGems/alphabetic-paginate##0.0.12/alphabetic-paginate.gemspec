# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alphabetic_paginate/version'

Gem::Specification.new do |spec|
spec.name = 'alphabetic-paginate'
  spec.version       = AlphabeticPaginate::VERSION
  spec.authors       = ["Oleg Grishin", "Linglian Zhang"]
  spec.email         = ["og402@nyu.edu", "lz781@nyu.edu"]
  spec.description   = "Paginates in alphabetic groups"
  spec.summary       = "Creates pagination where all data is sorted into pages based on the first letter of the sorting value"
  spec.homepage      = "https://github.com/grishinoleg/alphabetic_paginate"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib","app"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.6"
  spec.add_dependency "i18n", "~> 0.6.1"
  spec.add_dependency "activesupport"
  spec.add_dependency "railties", "~> 3.1"

spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end