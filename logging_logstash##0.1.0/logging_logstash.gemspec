# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logging/logstash/version'

Gem::Specification.new do |spec|
spec.name = 'logging_logstash'
  spec.version       = Logging::Logstash::VERSION
  spec.authors       = ["Peter Schrammel"]
  spec.email         = ["peter.schrammel@gmx.de"]
  spec.summary       = %q{A loggstash appender for the logging framework.}
  spec.description   = %q{Allows you to log your mdc and hashes to logstash and keep the key-values for later analysis}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  
  spec.add_dependency "logging", "~> 1.8.1"
  spec.add_dependency "logstash-logger", "~> 0.7.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end