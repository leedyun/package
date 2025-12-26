Gem::Specification.new do |s|
s.name = 'city-search'
  s.version     = '0.0.4'
  s.date        = '2019-05-04'
  s.summary     = "City Search"
  s.description = "Finds cities"
  s.authors     = ["Maksatbek Mansurov"]
  s.email       = 'maksat.mansov@gmail.com'
  s.files       =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.homepage    = 'http://rubygems.org/gems/city_search'
  s.license     = 'MIT'
  s.require_paths = ["lib"]
  s.add_runtime_dependency 'dawg', '~> 0.0', '>= 0.0.5'
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end