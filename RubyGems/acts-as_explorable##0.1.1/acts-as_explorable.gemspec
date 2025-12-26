$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'acts_as_explorable/version'

Gem::Specification.new do |s|
s.name = 'acts-as_explorable'
  s.version     = ActsAsExplorable::VERSION
  s.authors     = ['Mathias Schneider']
  s.email       = ['mathias@hiasinho.com']
  s.homepage    = 'https://github.com/hiasinho/acts_as_explorable'
  s.summary     = 'Adds GitHub-like search function to your models'
  s.description = 'Adds GitHub-like search function to your models'
  s.license     = 'MIT'

  s.files                 =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.test_files            = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths         = ['lib']
  s.required_ruby_version = '>= 2.0.0'

  s.add_runtime_dependency 'activerecord',  ['>= 4.0', '< 5']

  s.add_development_dependency 'sqlite3'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'factory_girl_rails', '~> 4.0'
  s.add_development_dependency 'database_cleaner'
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end