Gem::Specification.new do |gem|
gem.name = 'activerecord_duplicate'
  gem.version       = '0.6.1'
  gem.authors       = 'Mario Uher'
  gem.email         = 'uher.mario@gmail.com'
  gem.description   = gem.summary = 'Duplicating ActiveRecords is easy again.'
  gem.homepage      = 'https://github.com/haihappen/activerecord-duplicate'

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.require_path  = 'lib'

  gem.add_dependency 'activerecord', '>= 3.1'

  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'purdytest'
  gem.add_development_dependency 'rails', '>= 3.1'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'sqlite3'
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end