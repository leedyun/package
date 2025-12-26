# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acmesmith-google-cloud-storage/version'

Gem::Specification.new do |spec|
spec.name = 'acmesmith_google-cloud-storage'
  spec.version       = AcmesmithGoogleCloudStorage::VERSION
  spec.authors       = ["YAMADA Tsuyoshi"]
  spec.email         = ["tyamada@minimum2scp.org"]

  spec.summary       = %q{acmesmith plugin implementing google_cloud_storage storage}
  spec.description   = %q{acmesmith plugin implementing google_cloud_storage storage}
  spec.homepage      = "https://github.com/minimum2scp/acmesmith-google-cloud-storage"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "acmesmith"
  spec.add_dependency "google-api-client"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end