# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asset_pipeline/version'

Gem::Specification.new do |spec|
spec.name = 'asset-pipeline'
  spec.version       = AssetPipeline::VERSION
  spec.authors       = ['Vlad Faust']
  spec.email         = ['vladislav.faust@gmail.com']

  spec.summary       = %q{Sprockets-based Asset Pipeline for Ruby applications}
  spec.description   = %q{Boost your plain Ruby applications with neat assets served by Sprockets!}
  spec.homepage      = 'https://github.com/vladfaust/asset_pipeline'
  spec.license       = 'MIT'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'sprockets'
  spec.add_dependency 'sprockets-helpers'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake',    '~> 10.0'
  spec.add_development_dependency 'rspec',   '~> 3.0'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end