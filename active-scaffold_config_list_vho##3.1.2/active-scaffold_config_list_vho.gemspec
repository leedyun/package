# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'active_scaffold_config_list/version'

Gem::Specification.new do |s|
s.name = 'active-scaffold_config_list_vho'
  s.version = ActiveScaffoldConfigList::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.authors = ["Volker Hochstein"]
  s.date = %q{2012-02-11}
  s.description = %q{User may reorder and hide/show list columns}
  s.email = %q{activescaffold@googlegroups.com}
  s.extra_rdoc_files = [
      "README"
  ]
  s.files =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.homepage = %q{http://github.com/vhochstein/active_scaffold_config_list}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.summary = %q{User specific column configuration for ActiveScaffold}

  s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
  s.add_runtime_dependency(%q<active_scaffold_vho>, [">= 3.1.2"])
  s.add_development_dependency(%q<simplecov>, ["~> 0.9.0"])

s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]

end