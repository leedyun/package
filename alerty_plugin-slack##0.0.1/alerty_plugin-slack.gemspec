# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alerty/plugin/slack/version'

Gem::Specification.new do |spec|
spec.name = 'alerty_plugin-slack'
  spec.version       = Alerty::Plugin::Slack::VERSION
  spec.authors       = ["Naotoshi Seo"]
  spec.email         = ["sonots@gmail.com"]

  spec.summary       = %q{Slack plugin for alerty.}
  spec.description   = %q{Slack plugin for alerty.}
  spec.homepage      = "https://github.com/sonots/alerty-plugin-slack"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "alerty"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end