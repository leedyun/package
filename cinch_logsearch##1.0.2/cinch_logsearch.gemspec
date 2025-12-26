# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cinch/plugins/logsearch/version'

Gem::Specification.new do |gem|
gem.name = 'cinch_logsearch'
  gem.version       = Cinch::Plugins::LogSearch::VERSION
  gem.authors       = ['Brian Haberer']
  gem.email         = ['bhaberer@gmail.com']
  gem.description   = %q(Cinch Plugin to search log files for users.)
  gem.summary       = %q(Cinch Plugin for searching irc logs.)
  gem.homepage      = 'https://github.com/bhaberer/cinch-logsearch'
  gem.license       = 'MIT'
  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(/^bin\//).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(/^(test|spec|features)\//)
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake', '~> 10'
  gem.add_development_dependency 'rspec', '~> 3'
  gem.add_development_dependency 'coveralls', '~> 0.7'
  gem.add_development_dependency 'cinch-test', '~> 0.1', '>= 0.1.0'
  gem.add_dependency 'cinch', '~> 2'
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end