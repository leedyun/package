# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_model/permalink/version'

Gem::Specification.new do |spec|
spec.name = 'active-model-permalink'
  spec.version       = ActiveModel::Permalink::VERSION
  spec.authors       = ["Attila Györffy"]
  spec.email         = ["attila@attilagyorffy.com"]
  spec.summary       = %q{Simple permalink solution for ActiveModel objects}
  spec.description   = %q{ActiveModel::Permalink generates permalinks for your ActiveModel objects, including support for Mongoid.}
  spec.homepage      = "http://github.com/liquid/active_model-permalink"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activemodel", [">= 4.0"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end