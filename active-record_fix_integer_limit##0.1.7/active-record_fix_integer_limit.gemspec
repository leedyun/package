# coding: utf-8

$:.push File.expand_path("lib", __dir__)
require "active_record/fix_integer_limit/version"

Gem::Specification.new do |s|
s.name = 'active-record_fix_integer_limit'
  s.version     = ActiveRecord::FixIntegerLimit::VERSION
  s.authors     = ["hellekin"]
  s.email       = ["hellekin@cepheide.org"]
  s.homepage    = "https://gitlab.com/hellekin/active_record_fix_integer_limit"
  s.summary     = "Enable ActiveRecord unsigned integers to use 8 bytes instead of 4."
  s.description = "This fixes the DEFAULT_LIMIT set to 4 bytes in ActiveModel::Type:Integer."
  s.license     = "MIT"

  s.files       =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.bindir      = "exe"
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 2.5.1'
  
  s.add_runtime_dependency "activerecord", ">= 5.2.1"
  s.add_development_dependency "bundler", "~> 1.13"
  s.add_development_dependency "pry", "~> 0.11"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rails", "~> 5.2.1"
  s.add_development_dependency "rspec", "~> 3.7"
  s.add_development_dependency "sqlite3"
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end