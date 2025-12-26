# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'http_statsd/version'

Gem::Specification.new do |gem|
gem.name = 'http-statsd'
  gem.version       = HttpStatsd::VERSION
  gem.authors       = ["Grzesiek Kolodziejczyk"]
  gem.email         = ["gk@code-fu.pl"]
  gem.summary       = %q{HTTP proxy for statsd with basic auth}
  gem.homepage      = "https://github.com/grk/http_statsd"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "sinatra"
  gem.add_runtime_dependency "statsd-ruby"
  gem.add_runtime_dependency "httparty"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rack-test"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "rake"
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end