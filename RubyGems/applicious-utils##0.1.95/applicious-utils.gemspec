# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "applicious_utils/version"

Gem::Specification.new do |s|
s.name = 'applicious-utils'
  s.version     = AppliciousUtils::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Applicious"]
  s.email       = ["mail@appliciousagency.com"]
  s.homepage    = "http://appliciousagency.com"
  s.summary     = %q{Applicious Utilities}
  s.description = %q{Helper JS & Ruby Functions}

  s.rubyforge_project = "applicious_utils"

  #s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.files         = Dir['**/*'].reject {|fn| File.directory?(fn) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  #s.add_dependency('log4r', '>= 1.0.5')
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]

# Usage
# $ gem build applicious_utils.gemspec 
# $ gem push applicious_utils-
end