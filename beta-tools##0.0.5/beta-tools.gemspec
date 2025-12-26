# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "beta_tools/version"

Gem::Specification.new do |s|
s.name = 'beta-tools'
  s.version     = BetaTools::VERSION
  s.authors     = ["Fenton Travers"]
  s.email       = ["fenton.travers@oracle.com"]
  s.homepage    = ""
  s.summary     = %q{tools that are working and not in active development, to cutdown on rake install time}
  s.description = %q{tools that are working and not in active development, to cutdown on rake install time}
  s.rubyforge_project = "beta_tools"

  s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "pygments.rb"
  s.add_dependency "RedCloth"
  s.add_dependency "redcarpet"
  s.add_dependency "shotgun"
  s.add_dependency "sinatra"
  s.add_dependency "mime-types"
  s.add_dependency "sanitize"
  s.add_dependency "xml-simple"
  s.add_dependency "it_tools"
  s.add_dependency "thin"

s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end