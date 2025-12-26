Gem::Specification.new do |s|

s.name = 'logstash_2-output-rollbar'
  s.version         = "0.1.0"
  s.licenses        = ["Apache License (2.0)"]
  s.summary         = "The Rollbar Logstash output sends events to the Rollbar error monitoring service."
  s.description     = "This gem is a logstash plugin. Install using: $LS_HOME/bin/plugin install gemname. This gem is not a stand-alone program"
  s.authors         = ["Rollbar", "Filip Tepper"]
  s.email           = "support@rollbar.com"
  s.homepage        = "https://github.com/filiptepper/logstash-2-output-rollbar"
  s.require_paths = ["lib"]

  # Files
  s.files =Dir['**/*'].keep_if { |file| File.file?(file) }

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 1.0"
  s.add_development_dependency "logstash-devutils"
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]

end