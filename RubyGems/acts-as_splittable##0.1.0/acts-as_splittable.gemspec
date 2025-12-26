$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_splittable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
s.name = 'acts-as_splittable'
  s.version     = ActsAsSplittable::VERSION
  s.authors     = ["tatat", "takkkun", "wneko"]
  s.email       = ["ioiioioloo@gmail.com", "heartery@gmail.com", "aoki@u-ne.co"]
  s.homepage    = "https://github.com/tatat/acts_as_splittable"
  s.summary     = "Create virtual attributes."
  s.description = "Create virtual attributes."

  s.files       =Dir['**/*'].keep_if { |file| File.file?(file) }

  s.add_dependency 'rails', ['>= 3', '< 5']

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end