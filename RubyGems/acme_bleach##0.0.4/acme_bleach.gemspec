# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acme/bleach/version'

Gem::Specification.new do |spec|
spec.name = 'acme_bleach'
  spec.version       = Acme::Bleach::VERSION
  spec.authors       = ["Jason King"]
  spec.email         = ["jk@handle.it"]
  spec.description   = %q{The first time you run your code after requiring this module it will bleach your file, your code still runs but you can no longer see it, needs Ruby >= 1.9}
  spec.summary       = %q{Bleaches your source file}
  spec.homepage      = "https://github.com/smathy/acme-bleach"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end