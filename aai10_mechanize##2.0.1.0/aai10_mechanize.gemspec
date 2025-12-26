# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
s.name = 'aai10_mechanize'
  s.version     = "2.0.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alexey Aleksandrov"]
  s.email       = ["aai10@mail.msiu.ru	"]
  s.homepage    = ""
  s.summary     = %q{Mechanize Bug Fix}
  s.description = %q{Fix error in mechanize}

  s.rubyforge_project = "aai10-mechanize"

  s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end