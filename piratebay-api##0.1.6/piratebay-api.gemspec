# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'piratebay_api/version'

Gem::Specification.new do |spec|
spec.name = 'piratebay-api'
  spec.version       = PiratebayApi::VERSION
  spec.authors       = ['Dani']
  spec.email         = ['gomess13@bitbucket.org']
  spec.summary       = %q{Allow to retrieve result search from pirate bay.}
  spec.description   = %q{}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'hpricot', '~> 0'
  spec.add_runtime_dependency 'awesome_print', '~> 0'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end