require "rake/testtask"
require "yard"
require "yard/rake/yardoc_task"

Rake::TestTask.new do |t|
  t.verbose = true
  t.libs.push("test")
  t.pattern = "test/**/*_test.rb"
end

YARD::Rake::YardocTask.new do |t|
  t.before  = Proc.new do
    puts "\n[YARD] Generating documentation\n\n"
  end
  t.files   = ['lib/**/*.rb']
  # --quiet / --verbose =>
  t.options = ['--quiet', '--list-undoc', '--compact', '--verbose']
end

task :default => [:test, :yard]

task :example_data do
  require "example_data"
  example = ExampleData.new
  example.parse_org(  example.url_builder("orgs/railsinstaller/repos") )
  example.parse_repo( example.url_builder("repos/rvm/pluginator/contributors") )
  example.parse_repo( example.url_builder("repos/mpapis/rubygems-bundler/contributors") )
end
