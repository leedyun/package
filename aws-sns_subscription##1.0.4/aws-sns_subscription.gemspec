# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aws_sns_subscription/version'

Gem::Specification.new do |gem|
gem.name = 'aws-sns_subscription'
  gem.version       = AWSSNSSubscription::VERSION
  gem.authors       = ["Sean Devine"]
  gem.email         = ["sean@buytruckload.com"]
  gem.description   = %q{Easy confirmation of Amazon SNS subscription requests in Rails apps}
  gem.summary       = %q{Auto responds to AWS SNS subscription confirmations}
  gem.homepage      = ""

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activesupport"
  gem.add_dependency "httparty"

  gem.add_development_dependency "rspec"
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end