# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/airbrake/version'

Gem::Specification.new do |spec|
spec.name = 'capistrano_airbrake'
  spec.version       = Capistrano::Airbrake::VERSION
  spec.authors       = ["Patrick Helm"]
  spec.email         = ["deradon87@gmail.com"]
  spec.description   = %q{Airbrake integration for Capistrano}
  spec.summary       = %q{Airbrake integration for Capistrano}
  spec.homepage      = "https://github.com/Deradon/capistrano-airbrake"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'capistrano', '~> 3.0'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end