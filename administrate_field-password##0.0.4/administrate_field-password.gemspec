$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |gem|
gem.name = 'administrate_field-password'
  gem.version = '0.0.4'
  gem.authors = ['Adrian Rangel']
  gem.email = ['adrian@disruptiveangels.com']
  gem.homepage = 'https://github.com/disruptiveangels/administrate-field-password'
  gem.summary = 'Add Password fields to Administrate'
  gem.description = 'Easily add Password fields to your administrate views'
  gem.license = 'MIT'

  gem.require_paths = ['lib']
  gem.files =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.add_dependency 'administrate'
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end