# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a14z6ch_elapsed_days/version'

Gem::Specification.new do |spec|
spec.name = 'a14z6ch-elapsed_days'
  spec.version       = A14z6chElapsedDays::VERSION
  spec.authors       = ["Chihiro Hashimoto"]
  spec.email         = ["a14z6ch@aiit.ac.jp"]
  spec.summary       = %q{To calculate days from given date.}
  spec.description   = %q{To calculate days from given date.}
  spec.homepage      = "https://github.com/chrhsmt/a14z6ch_elapsed_days"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "colorize"
  spec.add_runtime_dependency "thor"
#  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end