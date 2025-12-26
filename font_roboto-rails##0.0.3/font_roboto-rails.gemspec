$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'font-roboto-rails/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
spec.name = 'font_roboto-rails'
  spec.version       = FontRobotoRails::VERSION
  spec.authors       = ['Vladimir Radetsky']
  spec.email         = ['chezka.rus@gmail.com']
  spec.homepage      = 'https://rubygems.org/gems/font-roboto-rails'
  spec.summary       = 'Font Roboto Rails - Roboto font for rails.'
  spec.description   = 'Just font'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.require_paths = ['lib']

  spec.add_dependency 'less'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'less-rails'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end