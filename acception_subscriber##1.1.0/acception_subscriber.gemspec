# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acception/subscriber/version'

Gem::Specification.new do |spec|
spec.name = 'acception_subscriber'
  spec.version       = Acception::Subscriber::VERSION
  spec.authors       = ["C. Jason Harrelson"]
  spec.email         = ["cjharrelson@iberon.com"]
  spec.summary       = %q{A RabbitMQ subscriber that pushes messages to Acception's API.}
  spec.description   = %q{A RabbitMQ subscriber that pushes messages to Acception's API.  See README for more details.}
  spec.homepage      = "https://gitlab.staging.iberon.com/common/acception-subscriber"
  spec.license       = ""

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency "acception-client", ">= 1.2"
  spec.add_dependency "bunny", "~> 1"
  spec.add_dependency "celluloid", "~> 0"
  spec.add_dependency "multi_json", "~> 1"
  spec.add_dependency "oj", "~> 2"
  spec.add_dependency "trollop", "~> 2"
  spec.add_dependency "yell", "~> 1"

spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end