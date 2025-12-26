lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acme/client/version'

Gem::Specification.new do |spec|
spec.name = 'acme_client'
  spec.version       = Acme::Client::VERSION
  spec.authors       = ['Charles Barbier']
  spec.email         = ['unixcharles@gmail.com']
  spec.summary       = 'Client for the ACME protocol.'
  spec.homepage      = 'http://github.com/unixcharles/acme-client'
  spec.license       = 'MIT'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_development_dependency 'bundler', '~> 1.6', '>= 1.6.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3', '>= 3.3.0'
  spec.add_development_dependency 'vcr', '~> 2.9', '>= 2.9.3'
  spec.add_development_dependency 'webmock', '~> 3.3'

  spec.add_runtime_dependency 'faraday', '~> 0.9', '>= 0.9.1'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end