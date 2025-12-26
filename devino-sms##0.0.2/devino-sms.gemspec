# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devino_sms/version"

Gem::Specification.new do |s|
s.name = 'devino-sms'
  s.version     = DevinoSms::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ivan Khlipitkin"]
  s.email       = ["ivan@1dev.ru"]
  s.homepage    = ""
  s.summary     = %q{Send sms with devinotele.com}
  s.description = %q{Send sms with devinotele.com}

  s.rubyforge_project = "devino_sms"

  s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'patron', '0.4.16'
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end