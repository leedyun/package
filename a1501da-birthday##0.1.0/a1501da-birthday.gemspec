# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a1501da_birthday/version'

Gem::Specification.new do |spec|
spec.name = 'a1501da-birthday'
  spec.version       = A1501daBirthday::VERSION
  spec.authors       = ["a1501da"]
  spec.email         = ["a1501da@aiit.co.jp"]

  spec.summary       = %q{a simple age calculation.}
  spec.description   = %q{a simple age calculation.}
  spec.homepage      = "https://github.com/a1501/a1501da_birthday"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end