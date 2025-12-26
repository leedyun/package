# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bosh/plugin_generator/version'

Gem::Specification.new do |spec|
spec.name = 'bosh_plugin-generator'
  spec.version       = Bosh::PluginGenerator::VERSION
  spec.authors       = ["Alex Lomov"]
  spec.email         = ["lomov.as@gmail.com"]
  spec.description   = %q{Create file system tree structure for BOSH plugin development.}
  spec.summary       = %q{This gem creates file system tree structure for BOSH plugin. BOSH installs and updates software packages on large numbers of VMs over many IaaS providers with the absolute minimum of configuration changes.}
  spec.homepage      = "http://altoros.com"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency "bosh_cli",  ">= 1.2682.0"
  spec.add_runtime_dependency "bosh_common",  ">= 1.2682.0"
  spec.add_runtime_dependency "semi_semantic", "~> 1.1.0"
  spec.add_runtime_dependency "membrane", "~> 1.1.0"
  spec.add_runtime_dependency "git", "~> 1.2.6"
  spec.add_runtime_dependency "erubis", "~> 2.7.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "rspec-its", '~> 1.1.0'
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rspec-mocks"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end