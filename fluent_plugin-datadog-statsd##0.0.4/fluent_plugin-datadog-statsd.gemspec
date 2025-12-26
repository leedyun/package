# coding: utf-8

Gem::Specification.new do |spec|
spec.name = 'fluent_plugin-datadog-statsd'
  spec.version       = '0.0.4'
  spec.authors       = ['Kosuke Miyawaki']
  spec.email         = ['kikusumk3@gmail.com']
  spec.summary       = 'Fluentd output plugin for Dogstatsd.'
  spec.description   = 'Fluentd output plugin for Dogstatsd.'
  spec.homepage      = 'https://github.com/kikusu/fluent-plugin-datadog-statsd'
  spec.license       = 'MIT'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'fluentd', '~> 0.14'
  spec.add_dependency 'dogstatsd-ruby', '~> 3.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'test-unit-rr'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end