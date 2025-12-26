# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |spec|
spec.name = 'cap_drupal-multisite'
  spec.version     = "0.3.2"
  spec.authors     = ["Insiders Online"]
  spec.email       = ["beheer@insiders.nl"]
  spec.homepage    = "https://github.com/insiders/cap-drupal-multisite"
  spec.summary     = "[OUTDATED] A collection of capistrano tasks for deploying drupal sites"
  spec.description = spec.summary
  spec.license     = "MIT"

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", "~> 3.3.5"
  spec.add_dependency "sshkit", ">= 1.4.0"
  spec.add_dependency "colorize"
  spec.add_dependency "highline"
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end