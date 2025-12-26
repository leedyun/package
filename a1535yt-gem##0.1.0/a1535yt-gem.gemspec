# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a1535yt_gem/version'

Gem::Specification.new do |spec|
spec.name = 'a1535yt-gem'
  spec.version       = A1535ytGem::VERSION
  spec.authors       = ["takeshitou"]
  spec.email         = ["takeshitou@aiit.com"]

  spec.summary       = %q{aiit}
  spec.description   = %q{aiit}
  spec.homepage      = "http://aiit.ac.jp/"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end