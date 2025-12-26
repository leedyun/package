# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
s.name = 'active-merchant-mollie'
  s.version     = "0.1.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Berend"]
  s.email       = ["info@bluetools.nl"]
  s.homepage    = ""
  s.summary     = %q{ActiveMerchant extension to support the Dutch PSP Mollie with iDeal transactions}
  s.description = %q{ActiveMerchant extension to support the Dutch PSP Mollie with iDeal transactions}

  s.rubyforge_project = "active_merchant_mollie"

  s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('activemerchant')
  s.add_dependency('nokogiri')
  s.add_dependency('rspec')
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end