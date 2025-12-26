# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'at_least_one_existence_validator/version'

Gem::Specification.new do |spec|
spec.name = 'at-least_one_existence_validator'
  spec.version               = AtLeastOneExistenceValidator::VERSION
  spec.authors               = ["Valeriy Utyaganov"]
  spec.email                 = ["usawal@gmail.com"]
  spec.description           = %q{This validator tests whether associated collection is going to be empty after saving. It will be passed if at least one association of the specified collection will exist. The validator provides helper method and default error message.}
  spec.summary               = %q{Validator for associated collection}
  spec.homepage              = "http://github.com/USAWal/at_least_one_existence_validator"
  spec.license               = "MIT"

  spec.files                 =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables           = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files            = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths         = ["lib", "locales"]

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_runtime_dependency     "activemodel", ">= 3"

  spec.add_development_dependency "bundler"    , "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "activerecord"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end