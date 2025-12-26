Gem::Specification.new do |s|
s.name = 'acts-as_crafter'
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Justin French", "Vodka", "RailsCamp"]
  s.date = %q{2010-11-14}
  s.description = %q{Bring a little bit of Marcus Crafter awesomeness into your responses with this Rack Middleware}
  s.summary =     %q{Bring a little bit of Marcus Crafter awesomeness into your responses with this Rack Middleware}
  s.email = %q{justin@indent.com.au}
  s.homepage = %q{http://github.com/justinfrench/acts_as_crafter}
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end