# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'atacama_client/version'

Gem::Specification.new do |spec|
spec.name = 'atacama-client'
  spec.version       = AtacamaClient::VERSION
  spec.authors       = ["Coyô Software"]
  spec.email         = ["ti@coyo.com.br"]

  spec.summary       = %q{Atacama API integration}
  spec.description   = %q{Atacama API integration}
  spec.homepage      = "http://www.coyo.com.br"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug", "~> 8.2"

  spec.add_runtime_dependency "flexirest", "~> 1.3"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end