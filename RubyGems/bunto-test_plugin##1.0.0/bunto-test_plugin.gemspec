# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bunto_test_plugin/version'

Gem::Specification.new do |spec|
spec.name = 'bunto-test_plugin'
  spec.version       = BuntoTestPlugin::VERSION
  spec.authors       = ["Parker Moore", "Suriyaa Kudo"]
  spec.email         = ["parkrmoore@gmail.com", "SuriyaaKudoIsc@users.noreply.github.com"]
  spec.description   = %q{A test plugin for Bunto's 'gem' config option}
  spec.summary       = %q{A test Bunto plugin as a gem}
  spec.homepage      = "https://github.com/bunto/bunto-test-gem-plugin"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "bunto"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end