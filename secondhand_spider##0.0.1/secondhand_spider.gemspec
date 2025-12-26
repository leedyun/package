# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'secondhand/spider/version'

Gem::Specification.new do |spec|
spec.name = 'secondhand_spider'
  spec.version       = Secondhand::Spider::VERSION
  spec.authors       = ["loveltyoic"]
  spec.email         = ["loveltyoic@gmail.com"]
  spec.description   = %q{crawl secondhand infos from bbs}
  spec.summary       = %q{crawl secondhand infos from bbs}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end