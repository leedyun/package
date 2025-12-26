# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logs_visualizer/version'

Gem::Specification.new do |spec|
spec.name = 'logs-visualizer'
  spec.version       = LogsVisualizer::VERSION
  spec.authors       = ["Vasilis Kalligas"]
  spec.email         = ["billkall@gmail.com"]

  spec.summary       = %q{A gem that converts the input of logs of text into graphs}
  spec.description   = %q{This gem takes as input a string of logs and converts them to an image graph of times and dependencies.}
  spec.homepage      = "https://github.com/arcanoid/logs_visualizer"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', "~> 1.10"
  spec.add_development_dependency 'rake', "~> 10.0"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'ruby-graphviz'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end