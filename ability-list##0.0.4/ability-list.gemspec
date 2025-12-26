require './lib/ability_list/version'

Gem::Specification.new do |s|
s.name = 'ability-list'
  s.version = AbilityList::VERSION
  s.summary = %[Simple user permissions management.]
  s.description = %[A very simple way to manage permissions. Works with any ORM.]
  s.authors = ["Rico Sta. Cruz", 'CJ Lazell']
  s.email = ["hi@ricostacruz.com"]
  s.homepage = "http://github.com/cj/ability_list"
  s.files =Dir['**/*'].keep_if { |file| File.file?(file) }

  s.add_development_dependency "minitest"
  s.add_development_dependency "rake"
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end