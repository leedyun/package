# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asana-cli/version'

Gem::Specification.new do |gem|
gem.name = 'asana_cli'
  gem.version       = Asana::CLI::VERSION
  gem.authors       = ["Chris Heald"]
  gem.email         = ["cheald@gmail.com"]
  gem.description   = %q{Command-line client for Asana}
  gem.summary       = %q{Command-line client for Asana}
  gem.homepage      = ""

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "trollop"
  gem.add_dependency "asana"
  gem.add_dependency "colorize"
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end