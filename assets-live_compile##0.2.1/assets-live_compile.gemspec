$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
s.name = 'assets-live_compile'
  s.license     = "LGPL-3.0"
  s.version     = '0.2.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Braulio Bhavamitra"]
  s.email       = ["brauliobo@gmail.com"]
  s.homepage    = %q{http://github.com/coletivoEITA/assets_live_compile}
  s.summary     = %q{Compile and save assets on demand instead of using rake assets:precompile}
  #s.description = %q{}
  
  s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "activesupport", '>= 3.1'
  s.add_runtime_dependency "rails", '>= 3.1'
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]

end