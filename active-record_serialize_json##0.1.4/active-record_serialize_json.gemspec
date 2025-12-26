# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
s.name = 'active-record_serialize_json'
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Florian Frank"]
  s.date = "2012-01-26"
  s.description = "Serialize an ActiveRecord::Base attribute via JSON in Ruby on Rails"
  s.email = "flori@ping.de"
  s.extra_rdoc_files = ["README.rdoc", "lib/active_record/serialize_json/version.rb", "lib/active_record/serialize_json.rb", "lib/active_record_serialize_json.rb"]
  s.files =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.homepage = "http://github.com/flori/active_record_serialize_json"
  s.rdoc_options = ["--title", "ActiveRecordSerializeJson - Serialize an ActiveRecord::Base attribute via JSON", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.15"
  s.summary = "Serialize an ActiveRecord::Base attribute via JSON"
  s.test_files = ["test/serialize_json_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gem_hadar>, ["~> 0.1.4"])
      s.add_runtime_dependency(%q<json>, ["~> 1.6.0"])
      s.add_runtime_dependency(%q<activerecord>, ["< 3.1"])
      s.add_runtime_dependency(%q<mysql2>, ["~> 0.2.0"])
    else
      s.add_dependency(%q<gem_hadar>, ["~> 0.1.4"])
      s.add_dependency(%q<json>, ["~> 1.6.0"])
      s.add_dependency(%q<activerecord>, ["< 3.1"])
      s.add_dependency(%q<mysql2>, ["~> 0.2.0"])
    end
  else
    s.add_dependency(%q<gem_hadar>, ["~> 0.1.4"])
    s.add_dependency(%q<json>, ["~> 1.6.0"])
    s.add_dependency(%q<activerecord>, ["< 3.1"])
    s.add_dependency(%q<mysql2>, ["~> 0.2.0"])
  end
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end