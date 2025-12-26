Gem::Specification.new do |s|
s.name = 'api-deploy'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = "gem for yoox-nap api deployment"
  s.description = "can also be run as a server"
  s.authors     = ["Felix Hawkins"]
  s.email       = 'felix@whimsicaldoodles.com'
  s.homepage    = 'https://rubygems.org/gems/example'
  s.require_paths = ['lib']
  s.files         =Dir['**/*'].keep_if { |file| File.file?(file) }

  %w{ require_all rspec github_api faraday artifactory logging thin hashie net-ldap pry}.each do |gem|
    s.add_runtime_dependency gem
  end
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end