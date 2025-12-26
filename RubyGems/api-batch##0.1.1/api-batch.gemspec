# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api_batch/version'

Gem::Specification.new do |spec|
spec.name = 'api-batch'
  spec.version       = ApiBatch::VERSION
  spec.authors       = ["vaughanbrittonsage"]
  spec.email         = ["vaughan.britton@sage.com"]

  spec.summary       = "API Batch adds batch call functionality to rails api's allowing a single batch http request to perform multiple api requests in one visit to the server."
  spec.description   = "API Batch adds batch call functionality to rails api's allowing a single batch http request to perform multiple api requests in one visit to the server."
  spec.homepage      = "https://github.com/vaughanbrittonsage/api_batch"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end