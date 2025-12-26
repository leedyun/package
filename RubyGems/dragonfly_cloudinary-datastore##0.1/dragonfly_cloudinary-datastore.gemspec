# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
gem.name = 'dragonfly_cloudinary-datastore'
  gem.version       = '0.1'
  gem.authors       = ["Prabhakar Kumar"]
  gem.email         = ["prabhakar97@gmail.com"]
  gem.description   = %q{Cloudinary based data store for Dragonfly. Works with the latest read write destory interface.}
  gem.summary       = %q{Cloudinary based data store for Dragonfly}
  gem.homepage      = "https://github.com/prabhakar97/dragonfly-cloudinary-datastore"
  gem.license       = "MIT"
  gem.extra_rdoc_files = ["LICENSE.txt", "README.md"]

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'dragonfly', '~> 1.0', '>= 1.0'
  gem.add_runtime_dependency 'cloudinary', '~> 1.3', '>= 1.3.0'
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end