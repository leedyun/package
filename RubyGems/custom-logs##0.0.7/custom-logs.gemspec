# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'custom_logs/version'

Gem::Specification.new do |spec|
spec.name = 'custom-logs'
  spec.version       = CustomLogs::VERSION
  spec.authors       = ["Marek Piechocki"]
  spec.email         = ["work@marek-piechocki.pl"]
  spec.summary       = "Add your logs to standard output"
  spec.description   = "Add your logs to standard output"
  spec.homepage      = "https://github.com/mapiech/custom_logs"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_dependency "remote_syslog_logger"

spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end