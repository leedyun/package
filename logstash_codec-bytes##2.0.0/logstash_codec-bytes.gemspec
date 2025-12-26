Gem::Specification.new do |s|
s.name = 'logstash_codec-bytes'
  s.version       = "2.0.0"
  s.licenses      = ["MIT"]
  s.authors       = ["Lob"]
  s.email         = ["support@lob.com"]
  s.description   = "Logstash codec plugin to chunk an input into an event every specified number of bytes."
  s.summary       = "Logstash codec plugin to chunk an input into an event every specified number of bytes."
  s.homepage      = "https://github.com/lob/logstash-codec-bytes"
  s.require_paths = ["lib"]

  s.files =Dir['**/*'].keep_if { |file| File.file?(file) }

  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "codec" }

  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"

  s.add_development_dependency "logstash-devutils"
  s.add_development_dependency "simplecov"
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end