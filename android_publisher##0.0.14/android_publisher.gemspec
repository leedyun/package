# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'android/publisher/version'

Gem::Specification.new do |spec|
spec.name = 'android_publisher'
  spec.version       = Android::Publisher::VERSION
  spec.authors       = ["Slawomir Smiechura"]
  spec.email         = ["slawomir@soundcloud.com"]
  spec.summary       = 'The gem allows you to upload and control your Google Android applications'
  spec.description   = ''
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency 'rake', '~>10.1.0'
  spec.add_development_dependency 'rspec', '>=2.14.1'
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "simplecov"


  spec.add_dependency 'oauth2'
  spec.add_dependency 'trollop'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end