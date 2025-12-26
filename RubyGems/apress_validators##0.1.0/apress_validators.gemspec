# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apress/validators/version'

Gem::Specification.new do |spec|
spec.name = 'apress_validators'
  spec.version       = Apress::Validators::VERSION
  spec.authors       = ['Pavel Galkin']
  spec.email         = ['paulriddle@openmailbox.org']
  spec.summary       = 'Validators for ActiveRecord and ActiveModel.'
  spec.description   = %q{The gem is supposed to contain validators
                          that can be used across multiple projects.}
  spec.homepage      = 'https://github.com/abak-press/apress-validators'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rails', '>= 3.1', '< 4.3'
  spec.add_runtime_dependency 'pg'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 3.1'
  spec.add_development_dependency 'rspec-rails', '>= 2.14.0'
  spec.add_development_dependency 'combustion', '>= 0.5.3'
  spec.add_development_dependency 'appraisal', '>= 1.0.2'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'pry-debugger'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end