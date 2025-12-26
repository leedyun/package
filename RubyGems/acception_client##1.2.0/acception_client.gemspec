# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acception/client/version'

Gem::Specification.new do |spec|
  spec.authors       = ["C. Jason Harrelson"]
  spec.email         = ["cjharrelson@iberon.com"]
  spec.summary       = %q{An API facade for the acception service.}
  spec.description   = %q{An API facade for the acception service.  See README for more info.}
  spec.homepage      = "https://gitlab.staging.iberon.com/common/acception_client"
  spec.license       = ""
spec.name = 'acception_client'
  spec.version       = Acception::Client::VERSION

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency "endow", "~> 1"
  spec.add_dependency "enumerative"
  spec.add_dependency "hashie"
  spec.add_dependency "oj"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end