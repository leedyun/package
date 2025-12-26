# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "drupal_fu/version"

Gem::Specification.new do |s|
s.name = 'drupal-fu'
  s.version     = DrupalFu::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Armand du Plessis"]
  s.email       = ["adp@bank.io"]
  s.homepage    = ""
  s.summary     = %q{Simple gem interface for pulling content from Drupal CMS}
  s.description = %q{Simple gem interface for pulling content from Drupal CMS}

  s.rubyforge_project = "drupal_fu"

  s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end