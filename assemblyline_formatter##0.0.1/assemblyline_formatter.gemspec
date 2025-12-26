# coding: utf-8

Gem::Specification.new do |spec|
spec.name = 'assemblyline_formatter'
  spec.version       = "0.0.1"
  spec.authors       = ["Ed Robinson"]
  spec.email         = ["ed.robinson@reevoo.com"]
  spec.summary       = %q{Rspec Formatter for Assemblyline}
  spec.description   = %q{Rspec Formatter for Assemblyline}
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