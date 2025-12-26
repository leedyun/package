# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluent/plugin/haproxy_stats/version'

Gem::Specification.new do |spec|
spec.name = 'fluent-plugin-haproxy-stats'
  spec.version       = Fluent::Plugin::HaproxyStats::VERSION
  spec.authors       = ["Yohei Kawahara"]
  spec.email         = [""]

  spec.summary       = %q{Fluentd plugin fo HAProxy info and stats}
  spec.description   = %q{Fluentd plugin fo HAProxy info and stats}
  spec.homepage      = ""

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "haproxy"  
  spec.add_runtime_dependency "fluentd"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end