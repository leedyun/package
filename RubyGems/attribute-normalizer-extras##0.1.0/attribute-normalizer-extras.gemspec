# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attribute_normalizer/extras/version'

Gem::Specification.new do |spec|
spec.name = 'attribute-normalizer-extras'
  spec.version       = AttributeNormalizer::Extras::VERSION
  spec.authors       = ["Darko Dosenovic", "Michael van den Beuken", "Ruben Estevez", "Jordan Babe", "Mathieu Gilbert", "Ryan Jones", "Jonathan Weyermann", "Jesse Doyle"]
  spec.email         = ["darko.dosenovic@ama.ab.ca", "michael.vandenbeuken@ama.ab.ca", "ruben.estevez@ama.ab.ca", "jordan.babe@ama.ab.ca", "mathieu.gilbert@ama.ab.ca", "ryan.jones@ama.ab.ca", "jonathan.weyermann@ama.ab.ca", "jesse.doyle@ama.ab.ca"]
  spec.summary       = %q{attribute_normalizer gem extras}
  spec.description   = %q{Specific normalizers that we commonly use in our apps}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-instafail"
  spec.add_development_dependency "simplecov"

  spec.add_runtime_dependency "attribute_normalizer", "~> 1.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end