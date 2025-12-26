$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'octopus/replication_tracking/version'

Gem::Specification.new do |s|
s.name = 'ar_octopus-replication-tracking'
  s.version = Octopus::ReplicationTracking::VERSION
  s.authors = ['Jongmyung Ha']
  s.email = ['jongmyung@stayntouch.com']
  s.homepage = 'https://github.com/jongmyung/octopus-replication-tracking'
  s.summary = 'Check master/slave replication position with Octopus'
  s.description = 'This gem allows you to find replication position with Octopus'

  s.files =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.1.0'

  s.add_dependency 'ar-octopus', '~> 0.8.6'

  s.add_development_dependency 'pry-byebug', '~> 3.4'
  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'rubocop', '~> 0.49.0'

  s.license = 'MIT'
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end