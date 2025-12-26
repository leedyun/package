lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'commandsy/plugin/version'

Gem::Specification.new do |spec|
spec.name = 'commandsy_plugin'
  spec.version       = Commandsy::Plugin::VERSION
  spec.authors       = ['Tony Burns']
  spec.email         = ['tony@tabolario.com']
  spec.summary       = 'Plugin framework for Ruby-based Commandsy Agent plugins.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/commandsy/commandsy-plugin-rb'
  spec.license       = 'Apache License, Version 2.0'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^spec\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end