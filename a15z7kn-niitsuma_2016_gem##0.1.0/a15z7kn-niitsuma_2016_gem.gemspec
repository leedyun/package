# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a15z7kn_niitsuma_2016_gem/version'

Gem::Specification.new do |spec|
spec.name = 'a15z7kn-niitsuma_2016_gem'
  spec.version       = A15z7knNiitsuma2016Gem::VERSION
  spec.authors       = ["niitsken"]
  spec.email         = ["e1614hn@aitt.ac.jp", "hoge@gmail.com"]

  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  spec.description   = %q{Write a longer description or delete this line.}
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end