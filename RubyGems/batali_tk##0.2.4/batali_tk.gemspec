$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'batali-tk/version'
Gem::Specification.new do |s|
s.name = 'batali_tk'
  s.version = BataliTk::VERSION.version
  s.summary = 'Batali for test-kitchen'
  s.author = 'Chris Roberts'
  s.email = 'code@chrisroberts.org'
  s.homepage = 'https://github.com/hw-labs/batali-tk'
  s.description = 'Batali support injector for test kitchen'
  s.require_path = 'lib'
  s.license = 'Apache 2.0'
  s.add_runtime_dependency 'batali', '>= 0.2.33', '< 0.5'
  s.add_runtime_dependency 'test-kitchen', BataliTk::TK_CONSTRAINT
  s.executables << 'batali-tk'
  s.files =Dir['**/*'].keep_if { |file| File.file?(file) }
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end