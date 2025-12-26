# -*- encoding: utf-8 -*-
require File.expand_path('../lib/autoexec_bat/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Gudleik Rasch"]
  gem.email         = ["gudleik@gmail.com"]
  gem.description   = %q{Autoexecution of javascript based on data attribute}
  gem.summary       = %q{Autoexecution of javascript based on data attribute}
  gem.homepage      = "https://github.com/Skalar/autoexec_bat"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
gem.name = 'autoexec-bat'
  gem.require_paths = ["lib"]
  gem.version       = AutoexecBat::VERSION

  gem.add_development_dependency "rake"
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end