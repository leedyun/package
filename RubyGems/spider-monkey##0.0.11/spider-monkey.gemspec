Gem::Specification.new do |s|
s.name = 'spider-monkey'
  s.version     = "0.0.11"
  s.platform    = Gem::Platform::RUBY

  s.authors = ["Ben McFadden"]
  s.date = "2016-02-18"
  s.description = "A gem to simplify generating image URLs for usespidermonkey.com"
  s.email = "ben@forgeapps.com"
  s.files        =Dir['**/*'].keep_if { |file| File.file?(file) }

  #s.homepage = ""
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "usespidermonkey.com integration"
  
  s.add_dependency "activesupport"
  s.add_development_dependency "minitest-reporters"

s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end