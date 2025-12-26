# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alias_to_method/version'

Gem::Specification.new do |spec|
spec.name = 'alias-to_method'
  spec.version       = AliasToMethod::VERSION
  spec.authors       = ["Karl Coelho"]
  spec.email         = ["karl.coelho1@gmail.com"]
  spec.summary       = %q{Allows you convert a string of alias methods to public methods.}
  spec.description   = %q{Allows you convert a string of alias methods to public methods.}
  spec.homepage      = "http://github.com/karlcoelho/alias_to_method"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end