# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'archive_uploader/version'

Gem::Specification.new do |spec|
spec.name = 'archive-uploader'
  spec.version       = ArchiveUploader::VERSION
  spec.authors       = ["Teodor Pripoae"]
  spec.email         = ["teodor.pripoae@gmail.com"]
  spec.description   = %q{Upload stats to stat_fu webserver}
  spec.summary       = %q{Upload stats to stat_fu webserver}
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