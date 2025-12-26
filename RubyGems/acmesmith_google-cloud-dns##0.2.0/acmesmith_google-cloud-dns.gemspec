# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acmesmith-google-cloud-dns/version'

Gem::Specification.new do |spec|
spec.name = 'acmesmith_google-cloud-dns'
  spec.version       = AcmesmithGoogleCloudDns::VERSION
  spec.authors       = ["Chikanaga Tomoyuki"]
  spec.email         = ["nagachika@ruby-lang.org"]

  spec.summary       = %q{acmesmith plugin implementing dns-01 using Google Cloud DNS}
  spec.description   = %q{This gem is a plugin for acmesmith and implements an automated dns-01 challenge responder using Google Cloud DNS}
  spec.homepage      = "https://github.com/nagachika/acmesmith-google-cloud-dns"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "acmesmith", "~> 2.0"
  spec.add_dependency "google-api-client"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '~> 3.0'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end