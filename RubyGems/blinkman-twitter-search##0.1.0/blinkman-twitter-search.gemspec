# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blinkman/twitter_search/version'

Gem::Specification.new do |spec|
spec.name = 'blinkman-twitter-search'
  spec.version       = Blinkman::TwitterSearch::VERSION
  spec.authors       = ['ru_shalm']
  spec.email         = ['ru_shalm@hazimu.com']
  spec.summary       = %q{Blinkman adapter for Twitter Search API.}
  spec.homepage      = 'https://github.com/rutan/blinkman-twitter_search'
  spec.licenses      = ['MIT']

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'blinkman'
  spec.add_dependency 'mihatter'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end