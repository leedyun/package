# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "artoo-crazyflie/version"

Gem::Specification.new do |s|
s.name = 'artoo_crazyflie'
  s.version     = Artoo::Crazyflie::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Adrian Zankich", "Ron Evans"]
  s.email       = ["artoo@hybridgroup.com"]
  s.homepage    = "https://github.com/hybridgroup/artoo-crazyflie"
  s.summary     = %q{Artoo adaptor and driver for Crazyflie}
  s.description = %q{Artoo adaptor and driver for Crazyflie}

  s.rubyforge_project = "artoo-crazyflie"

  s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'artoo', '>= 1.6.0'
  s.add_runtime_dependency 'hybridgroup-crubyflie'
  s.add_development_dependency 'minitest', '>= 5.0'
  s.add_development_dependency 'minitest-happy'
  s.add_development_dependency 'mocha', '>= 0.14.0'
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end