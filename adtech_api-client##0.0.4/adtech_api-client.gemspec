$: << File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
s.name = 'adtech_api-client'
  s.version     = '0.0.4'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['minsikzzang', 'ericescalante']
  s.email       = ['min.kim@factorymedia.com', 'eric.escalante@factorymedia.com', 'developers@factorymedia.com']
  s.homepage    = 'https://github.com/factorymedia/adtech-api-ruby-client'
  s.summary     = 'ADTech Classic API ruby client'
  s.description = 'ADTech Classic API ruby client'

  s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.require_paths = ['lib']
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end