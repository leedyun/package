# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
s.name = 'activerecord_db-tools'
  s.version = "0.0.1"

  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.authors     = ["Craig Kerstiens"]
  s.email       = "craig.kerstiens@gmail.com"
  s.homepage    = "http://github.com/craigkerstiens/activerecord-db-tools"
  s.summary     = "Read-only tool for databases"
  s.description = "A tool for setting your database to read-only mode allowing you to conduct migrations, move database, or condut other actions that may typically involve taking a database fully offline"
  s.required_ruby_version     = ">= 1.8.7"
  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "rails", ">= 3.1"
  s.add_dependency "rake"
  s.add_development_dependency "bundler"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "rspec", "~> 2.11"

  git_files            =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.files              = git_files
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables        = []
  s.require_paths      = %w(lib)
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end