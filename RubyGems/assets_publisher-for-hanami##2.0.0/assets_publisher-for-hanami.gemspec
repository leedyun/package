# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cabeza-de-termo/assets-publisher/version'

Gem::Specification.new do |spec|
spec.name = 'assets_publisher-for-hanami'
  spec.version       = CabezaDeTermo::AssetsPublisher::Publisher::VERSION
  spec.authors       = ["Martin Rubi"]
  spec.email         = ["martinrubi@gmail.com"]

  spec.summary       = %q{Framework to define and publish assets on your Hanami application.}
  spec.description   = %q{Framework to define and publish assets on your Hanami application.}
  spec.homepage      = "https://github.com/cabeza-de-termo/assets-publisher-for-hanami"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0'

  spec.add_dependency "cdt-utilities", "~> 0.3"
  spec.add_dependency "assets-library-for-hanami", "~> 3.0"
  spec.add_dependency "tilt", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sass"
  spec.add_development_dependency "coffee-script"
  spec.add_development_dependency "therubyracer"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end