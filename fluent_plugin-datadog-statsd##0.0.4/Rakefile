require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.verbose = false
  task.rspec_opts = '-c -fd --require spec_helper'
end

task default: :spec

RuboCop::RakeTask.new do |task|
  task.options = ['--color']
end
