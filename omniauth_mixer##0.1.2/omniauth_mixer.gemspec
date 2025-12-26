# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/mixer/version'

Gem::Specification.new do |spec|
spec.name = 'omniauth_mixer'
  spec.version       = OmniAuth::Mixer::VERSION
  spec.authors       = ['Dave Hartnoll "KeyMailer"','Jim Grimmett "KeyMailer"']
  spec.email         = ['jim.grimmett@keymailer.co']
  spec.summary       = 'Mixer OAuth2 Strategy for OmniAuth'
  spec.homepage      = 'https://github.com/KeyMailer/omniauth-mixer'
  spec.license       = 'MIT'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'omniauth-oauth2', '~> 1.6'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 0'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end