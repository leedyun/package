# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ar-find-in-batches-with-order/version'

Gem::Specification.new do |spec|
spec.name = 'ar_find-in-batches-with-order'
  spec.version       = ActiveRecord::FindInBatchesWithOrder::VERSION
  spec.authors       = ["Nam Chu Hoai"]
  spec.email         = ["nambrot@googlemail.com"]
  spec.summary       = "Allow find_in_batches with custom order property"
  spec.description   = "Allow find_in_batches with custom order property"
  spec.homepage      = "https://github.com/nambrot/ar-find-in-batches-with-order"
  spec.license       = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end