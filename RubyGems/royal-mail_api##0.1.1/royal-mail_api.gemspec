# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'royal_mail_api/version'

Gem::Specification.new do |spec|
spec.name = 'royal-mail_api'
  spec.version       = RoyalMailApi::VERSION
  spec.authors       = ["Srikanth Kunkulagunta"]
  spec.email         = ["srikanth.kunkulagunta@gmail.com"]

  spec.summary       = %q{ruby wrapper for Royal Mail's API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "savon", "~> 2.10"
  spec.add_dependency "activesupport", "~> 4"
  spec.add_dependency "httpclient", "~> 2.3"
  spec.add_development_dependency "vcr", "~> 2.9"
  spec.add_development_dependency "dotenv", "~> 2.0"
  spec.add_development_dependency "webmock", "~> 1.21"
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end