require "bundler/gem_tasks"
require "rake/testtask"
require "a1447ll_mini_test"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
end

task :default => :test

desc "Say hello to someone"
task :hello do
  my_class = A1447llMiniTest::MyClass.new
  print "Input your name: "
  name = STDIN.gets.chomp
  puts my_class.hello(name)
end

