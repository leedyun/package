# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'address_validate/version'

Gem::Specification.new do |spec|
spec.name = 'address-validate'
  spec.version       = AddressValidate::VERSION
  spec.authors       = ["Mary Lee"]
  spec.email         = ["marybethlee11@gmail.com"]

  spec.summary       = %q{USPS address validation api integration}
  spec.description   = %q{AddressValidate is a ruby wrapper for integrating with the USPS address validation api.}
  spec.homepage      = "https://github.com/marybethlee/address_validate"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency "ox", "~> 2.4.1"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end