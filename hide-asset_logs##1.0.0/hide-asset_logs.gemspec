# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hide_asset_logs/version'

Gem::Specification.new do |gem|
gem.name = 'hide-asset_logs'
  gem.version       = HideAssetLogs::VERSION
  gem.authors       = ["Nathan Broadbent"]
  gem.email         = ["nathan.f77@gmail.com"]
  gem.description   = %q{Stop asset requests from being logged in your terminal.}
  gem.summary       = %q{Hide asset logs}
  gem.homepage      = "http://github.com/ndbroadbent/hide_asset_logs"
  gem.license       = "MIT"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end