# -*- encoding: utf-8 -*-
require File.expand_path('../lib/admob_site_stats/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jason Sommerset"]
  gem.email         = ["jasommerset@gmail.com"]
  gem.description   = "Simple Wrapper for the AdMob API for Site Stats"
  gem.summary       = "Simple Wrapper for the AdMob API for Site Stats found at https://api.admob.com/v2/site/stats"
  gem.homepage      = "https://github.com/jasommerset/admob_site_stats"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
gem.name = 'admob-site_stats'
  gem.require_paths = ["lib"]
  gem.version       = AdmobSiteStats::VERSION
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end