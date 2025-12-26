# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/rails/logs/version'

Gem::Specification.new do |spec|
spec.name = 'capistrano_rails-logs-tail'
  spec.version       = Capistrano::Rails::Logs::VERSION
  spec.authors       = ['ayaya', 'oss92']
  spec.email         = ['ayaya@ayaya.tw', 'oss@findhotel.net']
  spec.summary       = %q(Tail logs from Ruby on Rails server.)
  spec.description   = %q(A capistrano task to tail logs from Ruby on Rails server.)
  spec.homepage      = 'https://github.com/FindHotel/capistrano-rails-logs-tail'
  spec.license       = 'MIT'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano',         '>= 3.4.0', '< 4.0.0'
  spec.add_dependency 'capistrano-rails'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end