Gem::Specification.new do |s|
s.name = 'applogger_ruby'
  s.version     = "0.5.3"
  s.authors     = ["Dirk Eisenberg"]
  s.email       = "info@applogger.io"
  s.description = "applogger.io SDK for Ruby"
  s.summary     = "The official Ruby SDK for the applogger.io service"
  s.homepage    = "https://github.com/applogger/applogger-ruby"
  s.license     = 'MIT'
  s.files       =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.executables = ['applogger']

  s.required_ruby_version = '>= 2.0.0'

  s.add_runtime_dependency('httparty', '~> 0.13')
  s.add_runtime_dependency('faye-websocket', '~> 0.7')
  s.add_runtime_dependency('macaddr', '~> 1.7')
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end