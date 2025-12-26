lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activeadmin/jfu_upload/version'

Gem::Specification.new do |spec|
spec.name = 'activeadmin-jfu_upload'
  spec.version       = ActiveAdmin::JfuUpload::VERSION
  spec.summary       = 'jQuery-File-Upload for ActiveAdmin'
  spec.description   = 'An Active Admin plugin to use jQuery-File-Upload component'
  spec.license       = 'MIT'
  spec.authors       = ['Mattia Roccoberton']
  spec.email         = 'mat@blocknot.es'
  spec.homepage      = 'https://github.com/blocknotes/activeadmin_jfu_upload'

  spec.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activeadmin', '~> 1.0'
spec.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end