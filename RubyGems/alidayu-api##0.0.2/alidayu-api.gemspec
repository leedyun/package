# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alidayu/version'

Gem::Specification.new do |spec|
spec.name = 'alidayu-api'
  spec.version       = Alidayu::VERSION
  spec.authors       = ["wangrui"]
  spec.email         = ["to_wangrui@163.com"]
  spec.summary       = %q{阿里大鱼API}
  spec.description   = %q{阿里大鱼短信发送，语音双呼，文本转语音通知等API的调用}
  spec.homepage      = "https://github.com/wangrui438/alidayu_api"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', "~> 3.4"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end