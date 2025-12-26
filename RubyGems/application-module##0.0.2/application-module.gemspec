# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'application_module/version'

Gem::Specification.new do |spec|
spec.name = 'application-module'
  spec.version       = ApplicationModule::VERSION
  spec.authors       = ["Levente Bagi"]
  spec.email         = ["bagilevi@gmail.com"]
  spec.description   = %q{Classes to help breaking down Rails app into modules}
  spec.summary       = %q{Classes to help breaking down Rails app into modules}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end