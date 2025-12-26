# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'accepts_nested_serialized_attributes/version'

Gem::Specification.new do |spec|
spec.name = 'accepts-nested_serialized_attributes'
  spec.version       = AcceptsNestedSerializedAttributes::VERSION
  spec.authors       = ["Diego Salazar"]
  spec.email         = ["diego@greyrobot.com"]
  spec.summary       = %q{Adds support for serializing nested associations that work with accepts_nested_attributes_for.}
  spec.description   = %q{A tiny hack for Rails to make Model#as_json(include: :association) return a hash with association keys suffixed with _attributes.}
  spec.homepage      = "https://github.com/DiegoSalazar/accepts_nested_serialized_attributes.git"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end