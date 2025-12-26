# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
spec.name = 'capistrano3_drupal'
  spec.version       = '0.0.1'
  spec.authors       = ['Grégoire David']
  spec.email         = ['gregoiredavid.pro@gmail.com']
  spec.description   = %q{Drupal deployment for Capistrano 3.x}
  spec.summary       = %q{Drupal deployment for Capistrano 3.x}
  spec.homepage      = 'https://github.com/gregoiredavid/capistrano3-drupal'
  spec.license       = 'MIT'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano', '>= 3.0.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end