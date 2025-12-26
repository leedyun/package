# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
spec.name = 'fluent_plugin-statsd-event'
  spec.version       = "0.1.1"
  spec.authors       = ["Atlassian"]

  spec.summary       = %q{fluentd plugin for statsd event}
  spec.description   = %q{fluentd plugin for statsd event}
  spec.homepage      = "https://github.com/atlassian/fluent-plugin-statsd_event"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.has_rdoc      = false

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit", "~>3.2.0"
  spec.add_development_dependency "mocha", "~>1.1.0"
  spec.add_runtime_dependency "dogstatsd-ruby", "~> 1.6.0"
  spec.add_runtime_dependency "fluentd", ">= 0.12.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end