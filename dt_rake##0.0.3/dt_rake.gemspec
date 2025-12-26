# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dt/rake/version'

Gem::Specification.new do |spec|
spec.name = 'dt_rake'
  spec.version       = Dt::Rake::VERSION
  spec.authors       = ["Neeraj"]
  spec.email         = ["neeraj.bhunwal@gmail.com"]
  spec.description   = "Rake helper methods for dt deploy gem"
  spec.summary       = "Rake helper methods for dt deploy gem"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end