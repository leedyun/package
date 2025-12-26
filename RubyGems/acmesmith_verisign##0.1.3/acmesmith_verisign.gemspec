# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acmesmith-verisign/version'

Gem::Specification.new do |spec|
spec.name = 'acmesmith_verisign'
  spec.version       = AcmesmithVerisign::VERSION
  spec.authors       = ['Ben Kaplan']

  spec.summary       = %q{acmesmith plugin implementing dns-01 using Verisign REST API}
  spec.description   = %q{This gem is a plugin for acmesmith and implements an automated dns-01 challenge responder using Verisign REST API.}
  spec.homepage      = 'https://github.com/benkap/acmesmith-verisign'
  spec.license       = 'MIT'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.0'
  spec.add_runtime_dependency 'acmesmith', '~> 2'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end