# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
spec.name = 'batch-it'
  spec.version       = File.read(File.join(File.dirname(__FILE__),"VERSION"))
  spec.authors       = ["Caleb Buxton"]
  spec.email         = ["me@cpb.ca"]
  spec.description   = %q{Batch process your erb markdown}
  spec.summary       = %q{Batch process your erb markdown}
  spec.homepage      = "http://github.com/cpb/batch_it"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "tilt", "~> 2.0"
  spec.add_dependency "redcarpet", "~> 3.0"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.0.beta1"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end