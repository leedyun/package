# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aligned_table'

Gem::Specification.new do |spec|
spec.name = 'aligned-table'
  spec.version       = AlignedTable::VERSION
  spec.authors       = ["Zak Kristjanson"]
  spec.email         = ["zak.kristjanson@gmail.com"]
  spec.summary       = "An easy way to create simple lightweight text tables."
  spec.homepage      = "https://github.com/ubercow/aligned_table"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end