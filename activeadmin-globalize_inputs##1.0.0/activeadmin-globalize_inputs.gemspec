# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["Slotos", "Lumos Labs"]
  gem.email         = ["info@lumoslabs.com"]
  gem.description   = %q{Implementation of globalize_fields - ActiveRecord-friendly globalize helper for ActiveAdmin.}
  gem.summary       = %q{globalize helper for ActiveAdmin.}
  gem.homepage      = "https://github.com/lumoslabs/activeadmin_globalize_inputs"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
gem.name = 'activeadmin-globalize_inputs'
  gem.require_paths = ["lib"]
  gem.version       = '1.0.0'

  gem.add_dependency "globalize"
  gem.add_dependency "activeadmin"
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end