# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aws_blue_green_deploy/version'

Gem::Specification.new do |spec|
spec.name = 'aws-blue_green_deploy'
  spec.version       = AwsBlueGreenDeploy::VERSION
  spec.authors       = ["Jon Parten"]
  spec.email         = ["jon.parten@gmail.com"]
  spec.summary       = %q{Provide an interface for conducting Blue Green deployments.}
  spec.description   = %q{Provide an interface for conducting Blue Green deployments in AWS EC2 using ASG's and ELB's.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"

  spec.add_runtime_dependency 'aws-sdk'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end