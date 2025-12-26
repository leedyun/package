# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alerty/plugin/datadog_event/version'

Gem::Specification.new do |spec|
spec.name = 'alerty_plugin-datadog-event'
  spec.version       = Alerty::Plugin::DatadogEvent::VERSION
  spec.authors       = ["Yohei Kawahara(inokappa)"]
  spec.email         = ["inokara@gmail.com"]

  spec.summary       = %q{alerty plugin for Datadog Event}
  spec.description   = %q{alerty plugin for Datadog Event}
  spec.homepage      = "https://github.com/inokappa/alerty-plugin-datadog_event"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end