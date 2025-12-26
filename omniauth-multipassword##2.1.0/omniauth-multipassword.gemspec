# frozen_string_literal: true

require File.expand_path('lib/omniauth/multipassword/version', __dir__)

Gem::Specification.new do |gem|
  gem.name          = 'omniauth-multipassword'
  gem.version       = Omniauth::Multipassword::VERSION
  gem.authors       = ['Jan Graichen']
  gem.email         = ['jgraichen@altimos.de']
  gem.description   = 'A OmniAuth strategy to authenticate using different passwort strategies.'
  gem.summary       = 'A OmniAuth strategy to authenticate using different passwort strategies.'
  gem.homepage      = 'https://github.com/jgraichen/omniauth-multipassword'
  gem.license       = 'MIT'

  gem.required_ruby_version = '>= 2.7'
  gem.metadata = {
    'rubygems_mfa_required' => 'true',
  }

  gem.executables   = `git ls-files -- bin/*`.split("\n").map {|f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.require_paths = ['lib']

  gem.add_dependency 'omniauth', '~> 2.0'
end
