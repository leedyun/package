# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alias_class/version'

Gem::Specification.new do |spec|
spec.name = 'alias-class'
  spec.version       = AliasClass::VERSION
  spec.authors       = ["GustavoCaso"]
  spec.email         = ["gustavocaso@gmail.com"]
  spec.summary       = %q{alias_class method to replace long class names for shorter ones}
  spec.description   = %q{A small piece of code that provide with the ability the alias class name to improve, or avoid typing long class names}
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '~> 0'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end