# -*- encoding: utf-8 -*-
require File.expand_path('../lib/angel_list/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Scott Ballantyne"]
  gem.email         = ["ussballantyne@gmail.com"]
  gem.description   = %q{wrapper for angel list}
  gem.summary       = %q{wrapper for angel list}
  gem.homepage      = ""

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
gem.name = 'angel-list'
  gem.require_paths = ["lib"]
  gem.version       = AngelList::VERSION
  gem.add_dependency(%q<faraday>, [">= 0"])
  gem.add_dependency(%q<hashie>, [">= 0"])
  gem.add_dependency(%q<yajl-ruby>, [">= 0"])
  gem.add_dependency(%q<oauth2>, [">= 0"])
  gem.add_dependency(%q<curb>, [">= 0"])
  gem.add_dependency(%q<nokogiri>, [">= 0"])
  gem.add_dependency(%q<hpricot>, [">= 0"])
  gem.add_development_dependency(%q<pry>, ['>= 0'])
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end