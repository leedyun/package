require File.join(File.dirname(__FILE__), 'gemspec.rb')
require File.join(File.dirname(__FILE__), 'lib', 'gollum-lib', 'version.rb')
  if RUBY_PLATFORM == 'java' then
    default_adapter = ['gollum-rjgit_adapter', '~> 0.3']
  elsif ENV['GOLLUM_ADAPTER'] == 'grit'
    default_adapter = ['gollum-grit_adapter', '~> 1.0']
  else
    default_adapter = ['gitlab-gollum-rugged_adapter', '~> 0.4.4.2']
  end
Gem::Specification.new &specification(Gollum::Lib::VERSION, default_adapter)
