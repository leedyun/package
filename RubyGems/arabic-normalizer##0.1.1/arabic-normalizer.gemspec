# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arabic_normalizer/version'

Gem::Specification.new do |spec|
spec.name = 'arabic-normalizer'
  spec.version       = ArabicNormalizer::VERSION
  spec.authors       = ["Jean Debs"]
  spec.email         = ["jean.el-debs@cookpad.com"]

  spec.summary       = %q{ArabicNormalizer is pure Ruby port of Arabic Normalizer from Lucene.}
  spec.description   = %q{ArabicNormalizer is pure Ruby port of Arabic Normalizer from Lucene.}
  spec.homepage      = "https://github.com/jeaneldebs/arabic_normalizer"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end