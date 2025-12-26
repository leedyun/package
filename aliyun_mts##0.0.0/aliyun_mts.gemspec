# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aliyun/mts/version'

Gem::Specification.new do |s|
s.name = 'aliyun_mts'
  s.version       = Aliyun::MTS::VERSION
  s.date          = '2016-08-23'
  s.summary       = "Ruby SDK for Aliyun MTS API development"
  s.description   = "Ruby SDK for Aliyun MTS API development"
  s.authors       = ["fwshun8023"]
  s.email         = ['fwshun8023@gmai.com']
  s.homepage      = 'https://github.com/fwshun8023/aliyun-mts'
  s.license       = 'MIT'

  s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake", "~> 11.2"
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end