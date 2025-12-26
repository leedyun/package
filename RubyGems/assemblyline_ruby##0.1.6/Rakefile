require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "reevoocop/rake_task"

RSpec::Core::RakeTask.new(:spec)
ReevooCop::RakeTask.new(:reevoocop)

task default: [:spec, :reevoocop]
