# vim: set filetype=ruby et sw=2 ts=2:

require 'gem_hadar'

GemHadar do
  name        'active_record_serialize_json'
  path_name   'active_record/serialize_json'
  path_module 'ActiveRecord::SerializeJSON'
  module_type :class
  author      'Florian Frank'
  email       'flori@ping.de'
  homepage    "http://github.com/flori/#{name}"
  summary     'Serialize an ActiveRecord::Base attribute via JSON'
  description "#{summary} in Ruby on Rails"
  test_dir    'test'
  ignore      '.*.sw[pon]', 'pkg', 'Gemfile.lock', '.rvmrc', 'coverage', '.DS_Store'
  readme      'README.rdoc'

  dependency  'json',         '~>1.6.0'
  dependency  'activerecord', '<3.1'
  dependency  'mysql2',       '~>0.2.0'
end
