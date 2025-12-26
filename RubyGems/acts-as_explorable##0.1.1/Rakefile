require 'rubygems'
require 'bundler/setup'

desc 'Default: run specs.'
task default: :spec

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.options << '--output-dir' << './doc'
  t.options << '--no-private'
  t.options << '--protected'
  t.options << '--readme' << 'README.md'
  t.options << '--hide-tag' << 'return'
  t.options << '--hide-tag' << 'param'
end

Bundler::GemHelper.install_tasks
