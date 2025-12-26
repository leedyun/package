# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
gem.name = 'aliyun_push'
  gem.version       = "0.1.0"
  gem.authors       = ["Eric Zhang"]
  gem.email         = ["i@qinix.com"]
  gem.description   = %q{Ruby SDK for Aliyun push service}
  gem.summary       = %q{Ruby SDK for Aliyun push service}
  gem.homepage      = "https://github.com/qinix/aliyun-push-ruby-sdk"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'httparty', '~> 0.13.7'

gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end