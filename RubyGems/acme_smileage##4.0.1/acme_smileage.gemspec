# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acme/smileage/version'

Gem::Specification.new do |spec|
spec.name = 'acme_smileage'
  spec.version       = Acme::Smileage::VERSION
  spec.authors       = ["nicochan99"]
  spec.email         = ["nicochan990@yahoo.co.jp"]
  spec.summary       = %q{All about Japanese pop star "S/mileage"}
  spec.description   = %q{"S/mileage" is one of highly famous Japanese pop stars.
This module, acme-smileage, provides an easy method to catch up with S/mileage.}
  spec.homepage      = "https://github.com/nicochan99/acme-smileage"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.2"
  spec.add_development_dependency "minitest", "~> 5.3"
  spec.add_runtime_dependency "amatch", '~> 0.3'
  spec.add_runtime_dependency "moji", '~> 1.6'
  spec.add_runtime_dependency "nokogiri", '~> 1.6'
  spec.add_runtime_dependency "thor", '~> 0.19'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end