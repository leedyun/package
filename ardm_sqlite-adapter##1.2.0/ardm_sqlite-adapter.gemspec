# encoding: utf-8

require File.expand_path('../lib/dm-sqlite-adapter/version', __FILE__)

Gem::Specification.new do |gem|
gem.name = 'ardm_sqlite-adapter'
  gem.version       = DataMapper::SqliteAdapter::VERSION

  gem.authors     = [ 'Martin Emde', 'Dan Kubb' ]
  gem.email       = [ 'me@martinemde.com', 'dan.kubb@gmail.com' ]
  gem.summary     = 'Ardm fork of dm-sqlite-adapter'
  gem.description = 'Sqlite3 Adapter for DataMapper'
  gem.homepage    = 'https://github.org/ar-dm/ardm-sqlite-adapter'
  gem.license     = 'MIT'

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.test_files    = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[ LICENSE README.md ]
  gem.require_paths = [ "lib" ]

  gem.add_runtime_dependency 'ardm-do-adapter', '~> 1.2'
  gem.add_runtime_dependency 'do_sqlite3',      '~> 0.10.6'

  gem.add_development_dependency 'ardm-migrations', '~> 1.2'
  gem.add_development_dependency 'rspec',           '~> 1.3'
  gem.add_development_dependency 'rake',            '~> 0.9'
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end