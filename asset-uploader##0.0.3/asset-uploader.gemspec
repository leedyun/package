# -*- encoding: utf-8 -*-
require File.expand_path('../lib/asset_uploader/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dave Thomas"]
  gem.email         = ["dave@pragprog.com"]
  gem.description   = %q{Support uploading of checksummed assets to S3}
  gem.summary       = gem.description
  gem.homepage      = ""

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
gem.name = 'asset-uploader'
  gem.require_paths = ["lib"]
  gem.version       = AssetUploader::VERSION
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end