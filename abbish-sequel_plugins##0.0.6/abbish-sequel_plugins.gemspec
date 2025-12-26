# coding: utf-8
require File.dirname(__FILE__) + '/lib/abbish_sequel_plugins'

Gem::Specification.new do |spec|
spec.name = 'abbish-sequel_plugins'
  spec.version       = Abbish::Sequel::Plugins::Version
  spec.authors       = ['abbish']
  spec.email         = ['me@abbish.com']
  spec.summary       = %q{Frequently used plugins for Sequel}
  spec.description   = %q{For more detail please visit https://github.com/abbish/abbish_sequel_plugins}
  spec.homepage      = 'https://github.com/abbish/abbish-sequel-plugins'
  spec.licenses      = ['MIT']
  spec.require_paths = %w(lib lib/model)
  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sequel"
  spec.add_development_dependency "sqlite3"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end