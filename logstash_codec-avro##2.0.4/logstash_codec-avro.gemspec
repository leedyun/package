Gem::Specification.new do |s|

s.name = 'logstash_codec-avro'
  s.version         = '2.0.4'
  s.licenses        = ['Apache License (2.0)']
  s.summary         = "Encode and decode avro formatted data"
  s.description     = "Encode and decode avro formatted data"
  s.authors         = ["Elastic"]
  s.email           = 'info@elastic.co'
  s.homepage        = "http://www.elastic.co/guide/en/logstash/current/index.html"
  s.require_paths   = ["lib"]

  # Files
  s.files =Dir['**/*'].keep_if { |file| File.file?(file) }

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "codec" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 1.0"

  s.add_runtime_dependency "avro"  #(Apache 2.0 license)

  s.add_development_dependency 'logstash-devutils'
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]

end