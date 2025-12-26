# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'advisors_command_client/version'

Gem::Specification.new do |spec|
spec.name = 'advisors-command_client'
  spec.version       = AdvisorsCommandClient::VERSION
  spec.authors       = ["Christopher Ostrowski"]
  spec.email         = ["chris@madebyfunction.com"]

  spec.summary       = %q{Ruby Client for integrating with Advisors Command CRM}
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/RepPro/AdvisorsCommand"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_dependency "akami", "~> 1.3"
  spec.add_dependency "typhoeus"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "virtus"
  spec.add_dependency 'parallel'
  spec.add_dependency 'awrence'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end