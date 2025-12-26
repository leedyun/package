# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asset_link/version'

Gem::Specification.new do |spec|
spec.name = 'asset-link'
  spec.version       = AssetLink::VERSION
  spec.authors       = ["Anton Antonov"]
  spec.email         = ["anton.antonov@castle.co"]

  spec.summary       = %q{Gem that allows to replace any asset with a light-weight link to a remote storage.}
  spec.description   = %q{This gem allows to replace any asset (image, CSS stylesheet, script, etc.) with a light-weight link to the same asset located at a remote storage (e.g. Amazon S3). The idea behind it is to reduce the size of the application deployment, especially when it is limited by a hosting service (e.g. max slug size at Heroku is 300MB).}
  spec.homepage      = "https://github.com/doubleton/asset_link"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "bin"
  spec.executables   = ["asset_link"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.0'

  spec.add_development_dependency "mime-types", "~> 3.0"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "fog", '~> 1.20'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end