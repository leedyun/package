# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moving_images/version'

Gem::Specification.new do |spec|
spec.name = 'moving-images'
  spec.version       = MovingImages::VERSION
  spec.authors       = ["Kevin Meaney"]
  spec.email         = ["kevin@zukini.eu"]
  spec.summary       = %q{Ruby interface for using MovingImages}
  spec.description   = %q{Creates the JSON output required by MovingImages}
  spec.homepage      = "http://zukini.eu"
  spec.license       = "MIT"

  spec.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.required_ruby_version = '~> 2.0'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end