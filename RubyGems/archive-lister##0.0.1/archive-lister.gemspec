# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'archive_lister/version'

Gem::Specification.new do |gem|
gem.name = 'archive-lister'
  gem.version       = ArchiveLister::VERSION
  gem.authors       = ['Russell Garner']
  gem.email         = ['rgarner@zephyros-systems.co.uk']
  gem.description   = %q{Ask archives about URLs}
  gem.summary       = %q{Ask Wayback / TNA for URLs}
  gem.homepage      = 'https://github.com/rgarner/archive_lister'

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'nokogiri'
  gem.add_dependency 'addressable'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end