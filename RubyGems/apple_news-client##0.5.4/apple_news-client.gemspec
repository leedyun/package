# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apple-news/version'

Gem::Specification.new do |spec|
spec.name = 'apple_news-client'
  spec.version       = AppleNewsClient::VERSION
  spec.authors       = ["Benjamin Hargett", "Ryan LeFevre"]
  spec.email         = ["hargettbenjamin@gmail.com", "ryan@hodinkee.com"]

  spec.summary       = %q{Fully-featured library for working with the Apple News API.}
  spec.description   = %q{Fully-featured library for fetching and creating content with the Apple News API.}
  spec.homepage      = "https://github.com/bharget/apple-news-rb"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0.1"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "activesupport"
  spec.add_dependency "multipart-post"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end