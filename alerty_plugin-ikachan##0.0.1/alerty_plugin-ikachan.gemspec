# coding: utf-8

Gem::Specification.new do |spec|
spec.name = 'alerty_plugin-ikachan'
  spec.version       = "0.0.1"
  spec.authors       = ["Naotoshi Seo"]
  spec.email         = ["sonots@gmail.com"]

  spec.summary       = %q{ikachan plugin for alerty}
  spec.description   = %q{ikachan plugin for alerty}
  spec.homepage      = "https://github.com/sonots/alerty-plugin-ikachan"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "alerty"
  spec.add_runtime_dependency "ikachan-client"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end