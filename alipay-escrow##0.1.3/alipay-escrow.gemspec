# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alipay_escrow/version'

Gem::Specification.new do |spec|
spec.name = 'alipay-escrow'
  spec.version       = AlipayEscrow::VERSION
  spec.authors       = ["Akira Nakazawa"]
  spec.email         = ["nakazawa.akira@gmail.com"]

  spec.summary       = %q{A Ruby Interface to Alipay Payment Gateway. Unofficial.}
  spec.description   = %q{A Ruby Interface to Alipay Payment Gateway. Unofficial.}
  spec.homepage      = "https://github.com/konpeito/alipay_escrow"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "httparty"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end