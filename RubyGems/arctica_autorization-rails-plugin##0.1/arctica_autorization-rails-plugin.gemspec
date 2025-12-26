Gem::Specification.new do |s|
s.name = 'arctica_autorization-rails-plugin'
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexander V. Blid", "Alexander A. Doskov"]
  s.date = %q{2012-02-21}
  s.description = %q{Авторизация.}
  s.email = %q{support@itc-arctica.ru}
  s.files =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.has_rdoc = false
  s.homepage = %q{http://www.itc-arctica.ru}
  s.require_paths = ["lib"]
  #s.rubygems_version = %q{1.3.0}
  s.summary = %q{Autorization summary.}
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]end