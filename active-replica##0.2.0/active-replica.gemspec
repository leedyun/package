# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_replica/version'

Gem::Specification.new do |spec|
spec.name = 'active-replica'
  spec.version       = ActiveReplica::VERSION
  spec.authors       = ["Matthew Rudy Jacobs"]
  spec.email         = ["matthewrudyjacobs@gmail.com"]

  spec.summary       = %q{Simple, performant Read-Only replicas with ActiveRecord}
  spec.description   = %q{Add shards, and switch between them for key tasks}
  spec.homepage      = "https://github.com/gogovan/active_replica"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '>= 4.2.0', '< 5.1.0'
  spec.add_dependency 'activerecord', '>= 4.2.0', '< 5.1.0'
  spec.add_dependency 'concurrent-ruby', '~> 1.0'

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end