# coding: utf-8
VERSION = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |spec|
spec.name = 'backbone_subroute-rails'
  spec.version       = VERSION
  spec.authors       = ["Alexander Schwartzberg"]
  spec.email         = ["aeksco@gmail.com"]
  spec.summary       = "Rails asset wrapper for backbone.subroute"
  spec.homepage      = "https://github.com/aeksco/backbone-subroute-rails"
  spec.license       = "MIT"

  spec.files       =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.require_paths = ["lib"]
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end