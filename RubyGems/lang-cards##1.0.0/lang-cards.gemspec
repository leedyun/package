# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lang_cards/version'

Gem::Specification.new do |spec|
spec.name = 'lang-cards'
  spec.version       = LangCards::VERSION
  spec.authors       = ["Sebastjan Hribar"]
  spec.email         = ["sebastjan.hribar@gmail.com"]
  spec.description   = %q{This application supports you in learning foreing language vocabulary.}
  spec.summary       = %q{Language flash-cards application}
  spec.homepage      = "https://github.com/sebastjan-hribar/lang_cards"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = ["lang_cards"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "green_shoes", "=1.1.367"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end