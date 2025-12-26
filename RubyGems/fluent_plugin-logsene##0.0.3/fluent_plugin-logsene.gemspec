# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
spec.name = 'fluent_plugin-logsene'
  spec.version       = "0.0.3" 
  spec.authors       = ["Sematext"]
  spec.email         = ["info@sematext.com"]
  spec.description   = %q{fluent plugin for logsene}
  spec.summary       = %q{Logsene is a centralized log management solution from Sematext. The plugin is fluentd output plugin for Logsene}
  spec.homepage      = "https://github.com/mbonaci/fluent-plugin-logsene"
  spec.license       = "MIT"

  spec.rubyforge_project = "fluent-plugin-logsene"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "fluentd"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end