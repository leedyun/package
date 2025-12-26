# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'movie_spider/version'

Gem::Specification.new do |spec|
spec.name = 'movie-spider'
  spec.version       = MovieSpider::VERSION
  spec.authors       = ["hzlu"]
  spec.email         = ["hzlu2010@163.com"]
  spec.summary       = %q{fetch movies' infomation}
  spec.description   = %q{fetch Mtime and Douban, movie posters, stills, and rating.}
  spec.homepage      = "http://www.dan-che.com"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "nokogiri", "~> 2.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end