lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
spec.name = 'apptuit_fluent-plugin'
  spec.version = "0.1.3"
  spec.authors = ["hari prasad"]
  spec.email   = ["hariprasad.pothuri@agilitix.ai"]

  spec.summary       = %q{To find the fingerprints for errors}
  spec.homepage      = "https://github.com/hari9973/apptuit-fluent-plugin"
  spec.license       = "Apache-2.0"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "test-unit", "~> 3.0"
  spec.add_runtime_dependency "fluentd", [">= 0.14.10", "< 2"]
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "codecov", ">= 0.1.10"
  spec.required_ruby_version = '>= 2.3'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end