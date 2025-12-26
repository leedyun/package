# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lines_mixer/version'

Gem::Specification.new do |spec|
spec.name = 'lines-mixer'
  spec.version       = LinesMixer::VERSION
  spec.authors       = ["Piotr Szmielew"]
  spec.email         = ["p.szmielew@ava.waw.pl"]
  spec.summary       = %q{Simple gem for mixing lines in strings (created for Rails Girls Poznań).}
  spec.description   = %q{Simple gem for mixing lines in strings (created for Rails Girls Poznań).}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end