$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require "datadog/version"

Gem::Specification.new do |spec|
spec.name = 'datadog_cli'
  spec.version       = Datadog::VERSION
  spec.summary       = "Manage your datadog monitors"
  spec.description   = "Manage your datadog monitors."
  spec.homepage      = "https://github.com/jpedro/datadog-cli"
  spec.authors       = ["jpedro"]
  spec.email         = ["jpedro.barbosa@gmail.com"]
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "deep_merge"
  spec.add_dependency "thor"
  spec.add_dependency "http"
  spec.add_dependency "liquid"
  spec.add_dependency "jsonlint"
  spec.add_dependency "colorize"
  spec.add_dependency "tablelize"
  spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end