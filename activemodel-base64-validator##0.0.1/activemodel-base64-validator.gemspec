file = File.open(File.expand_path('../lib/base64_validator/version.rb', __FILE__))
version = file.read.scan(/\d+\.\d+\.\d+/).first
file.close

Gem::Specification.new do |spec|
spec.name = 'activemodel-base64-validator'
  spec.version         = version
  spec.authors         = ['Yuku Takahashi']
  spec.email           = ['yuku@qiita.com']
  spec.summary         = 'A base64 validator for Rails 3 and 4.'
  spec.homepage        = 'https://github.com/increments/activemodel-base64_validator'
  spec.license         = 'MIT'

  spec.files           =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.require_paths   = ['lib']

  spec.add_dependency 'activemodel'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end