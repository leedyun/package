lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'argentinian/validations/version'

Gem::Specification.new do |spec|
spec.name = 'argentinian_validations'
  spec.version       = Argentinian::Validations::VERSION
  spec.authors       = ['Alejandro Bezdjian']
  spec.email         = ['alebezdjian@gmail.com']
  spec.summary       = 'Validations for Argentinian specific information'
  spec.description   = 'Validations for Argentinian specific information'
  spec.homepage      = 'https://github.com/alebian/argentinian-validations'
  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end