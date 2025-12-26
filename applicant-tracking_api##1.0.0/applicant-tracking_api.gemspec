Gem::Specification.new do |s|
s.name = 'applicant-tracking_api'
  s.version     = '1.0.0'
  s.date        = '2015-09-30'
  s.summary     = "Applicant Tracking API access gem"
  s.authors     = ["Joshua Siler"]
  s.files       =Dir['**/*'].keep_if { |file| File.file?(file) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = %w[lib]
  s.required_ruby_version = '>= 1.9.3'
  s.add_runtime_dependency('activeresource', '>= 2.3.5')
s.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end