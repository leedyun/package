# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'authenticated_client/version'


Gem::Specification.new do |spec|
spec.name = 'authenticated-client'
  spec.version       = AuthenticatedClient::VERSION
  spec.authors       = ["Barney de Villiers"]
  spec.email         = ["barney.de.villiers@hetzner.co.za"]
  spec.description   = %q{Client livrary for accessing authenticated resources}
  spec.summary       = %q{Client livrary for accessing authenticated resources such as token based systems}
  spec.homepage      = "https://gitlab.host-h.net/hetznerZA/authenticated-client"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'pry', '~> 0'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 2.13'
  spec.add_development_dependency "capybara", '~> 2.1', '>= 2.1.0'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end