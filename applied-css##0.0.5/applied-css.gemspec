# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "applied_css/version"

Gem::Specification.new do |s|
s.name = 'applied-css'
  s.version     = AppliedCss::VERSION
  s.authors     = ["Stewart McKee"]
  s.email       = ["stewart@theizone.co.uk"]
  s.homepage    = ""
  s.summary     = "CSS and Script extraction tool for html documents"
  s.description = "Gem for interrogating CSS and Script elements of a html document"

  s.rubyforge_project = "applied_css"

  s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency "rspec"
  s.add_dependency "bundler"
  s.add_dependency "nokogiri"
  s.add_dependency "css_parser"
  s.add_dependency "fakeweb"
  s.add_dependency "awesome_print"
  s.add_dependency "addressable"
  s.add_dependency "cobweb"
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end