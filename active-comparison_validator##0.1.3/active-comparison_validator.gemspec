# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_comparison_validator/version'

Gem::Specification.new do |s|
s.name = 'active-comparison_validator'
  s.version       = ActiveComparisonValidator::VERSION
  s.authors       = ['onodera']
  s.email         = ['s1160054@gmail.com']

  s.summary       = 'Dynamically add validation for compare the column and the other column.'
  s.description   = 'This gem provides a macro for comparing the column and the other column of the record. Type of the comparable column is Date Time Numeric, and all that jazz.'
  s.homepage      = 'https://github.com/s1160054/active_comparison_validator'
  s.license       = 'MIT'

  s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.bindir        = 'exe'
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'activesupport', '>= 4.0.0'
  s.add_dependency 'activerecord', '>= 4.0.0'

  s.add_development_dependency 'rails', '>= 4.0.0'
  s.add_development_dependency 'bundler', '~> 1.10'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.2.0'
  s.add_development_dependency 'pry'
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end