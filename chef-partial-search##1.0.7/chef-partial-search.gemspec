# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
spec.name = 'chef-partial-search'
  spec.version       = "1.0.7"
  spec.authors       = ["Opscode, Inc"]
  spec.email         = ["cookbooks@opscode.com"]
  spec.summary       = "Provides experimental interface to partial search API in Opscode Hosted Chef"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/opscode-cookbooks/partial_search"
  spec.license       = "Apache 2.0"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["libraries"]

  spec.add_dependency 'chef', ">= 11.0.0"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end