# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano-logs/version'

Gem::Specification.new do |spec|
spec.name = 'capistrano_logs'
  spec.version       = CapistranoLogs::VERSION
  spec.authors       = ["Bob Breznak"]
  spec.email         = ["bob.breznak@gmail.com"]
  spec.description   = %q{Tasks that make it easy to view logs}
  spec.summary       = %q{Tasks that make it easy to view logs}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "capistrano"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end