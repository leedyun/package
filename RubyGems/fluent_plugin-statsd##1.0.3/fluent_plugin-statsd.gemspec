# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |gem|
gem.name = 'fluent_plugin-statsd'
  gem.description = "fluentd output plugin to send metrics to Esty StatsD monitor"
  gem.homepage    = "https://github.com/fakechris/fluent-plugin-statsd"
  gem.summary     = gem.description
  gem.version     = File.read("VERSION").strip
  gem.authors     = ["Chris Song"]
  gem.email       = "fakechris@gmail.com"
  gem.has_rdoc    = false
  gem.files       =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_dependency "fluentd", ">= 0.10.8"

  gem.add_development_dependency "rake", ">= 0.9.2"
  gem.add_development_dependency "statsd-ruby", ">=1.2.1"
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end