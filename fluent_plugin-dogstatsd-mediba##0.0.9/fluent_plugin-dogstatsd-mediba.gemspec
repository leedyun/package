# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluent/plugin/dogstatsd/version'

Gem::Specification.new do |spec|
spec.name = 'fluent_plugin-dogstatsd-mediba'
  spec.version       = Fluent::Plugin::Dogstatsd::VERSION
  spec.authors       = ["Hiroki Yoshida"]
  spec.email         = ["h-yoshida@mediba.jp"]
  spec.summary       = %q{Fluent plugin for Dogstatsd, that is statsd server for Datadog.}
  spec.homepage      = "https://github.com/yoshida-mediba/fluent-plugin-dogstatsd"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "fluentd"
  spec.add_dependency "dogstatsd-ruby", "~> 1.4.1"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end