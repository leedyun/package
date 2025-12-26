# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "activemodel_email_address_validator/version"

Gem::Specification.new do |spec|
spec.name = 'activemodel-email-address_validator'
  spec.version       = ActiveModelEmailAddressValidator::VERSION
  spec.authors       = ["Jakob Skjerning"]
  spec.email         = ["jakob@mentalized.net"]
  spec.summary       = "ActiveModel-style email address format validator"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", ">= 4.0", "< 7.0"

  spec.add_development_dependency "bundler", ">= 1.7"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "minitest"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end