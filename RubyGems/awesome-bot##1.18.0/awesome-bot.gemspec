# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'awesome_bot/version'

Gem::Specification.new do |spec|
  spec.name          = "awesome-bot"
  spec.version       = AwesomeBot::VERSION
  spec.authors       = ['Daniel Khamsing']
  spec.email         = ['dkhamsing8@gmail.com']

  spec.summary       = AwesomeBot::PROJECT_DESCRIPTION
  spec.description   = AwesomeBot::PROJECT_DESCRIPTION
  spec.homepage      = AwesomeBot::PROJECT_URL
  spec.license       = 'MIT'
  spec.bindir        = 'bin'
  spec.executables   = [AwesomeBot::PROJECT]
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency 'parallel', '1.12.0' # threading
  spec.files       = Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.extensions  = ['ext/trellislike/unflaming/waffling/extconf.rb']
end

