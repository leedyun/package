$:.unshift File.join(File.dirname(__FILE__), 'lib')

require "bundler/gem_tasks"
require 'rubygems'
require 'rubygems/package_task'
require 'rake'
require 'rake/testtask'
require 'rake/contrib/rubyforgepublisher'
require 'rdoc/task'

PKG_VERSION = "0.0.2"
PKG_NAME = "ebay_trading"
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"

PKG_FILES = FileList[
  "lib/**/*", "test/**/*", "examples/**/*", "[A-Z]*", "Rakefile", "init.rb"
].exclude(/~$|\.svn/)

response_dir = File.join(File.dirname(__FILE__), 'test', 'fixtures', 'responses')

desc "Default: Run all the unit tests"
task :default => [ 'test:units' ]

namespace :test do
  desc 'Run all unit tests.'
  Rake::TestTask.new(:units) do |t|
    t.libs << "test"
          t.pattern = 'test/unit/**/*_test.rb'
    t.verbose = true
  end
  
  desc 'Run all unit tests.'
  Rake::TestTask.new(:mapping) do |t|
    t.libs << "test"
          t.pattern = 'test/mapping/**/*_test.rb'
    t.verbose = true
  end
end

desc "Delete tar.gz / zip / rdoc"
task :cleanup => [ :clobber_package, :clobber_rdoc ]

namespace :schema do
  desc 'Get the latest version of the eBay XML schema'
  task :update do
    puts 'Updating the eBay schema'
  
      folder = File.dirname(__FILE__) + "/lib/ebay_trading/schema"
      url = 'http://developer.ebay.com/webservices/latest/ebaySvc.xsd'

      cd folder do
        rm_f 'ebaySvc.xsd'
        system("wget #{url}")
      end
  end

  desc "Update the schema version"
  task :update_version do
    schema = File.dirname(__FILE__) + '/lib/ebay_trading/schema/ebaySvc.xsd'
    # Update the schema version string

    File.read(schema) =~ /Version (\d+)/m
    if version = $1
      version_file_path = File.dirname(__FILE__) + "/lib/ebay_trading/schema/version.rb"
      version_file = File.read(version_file_path)
      version_file.gsub!(/VERSION = \d+/, "VERSION = #{version}")
      File.open(version_file_path, 'w') do |f|
        f.puts version_file
      end
    else
      raise "Unable to parse the version from the schema"
    end
  end
end

namespace :classes do
  desc "Remove the generated Ruby classes"
  task :cleanup do
    FileList[
      "lib/ebay_trading/requests.rb", "lib/ebay_trading/responses.rb", "lib/ebay_trading/types.rb", "lib/ebay_trading/requests/*.rb", 
      "lib/ebay_trading/responses/*.rb", "lib/ebay_trading/types/*.rb"
    ].each{|f| rm_rf f }
  end 
  
  desc "Generate Ruby classes from the schema file and updates the schema version"
  task :generate => [:cleanup, 'schema:update_version'] do
    require 'ebay_trading'
    require 'ebay_trading/schema/mapper'
    %w(requests responses types).each do |dir|
      folder = File.dirname(__FILE__) + "/lib/ebay_trading/#{dir}"
      Dir.mkdir(folder) unless File.directory?(folder)
    end
    schema = File.dirname(__FILE__) + '/lib/ebay_trading/schema/ebaySvc.xsd'
    data = File.read(schema)
    EbayTrading::Schema::XSD2eBay.run(data, File.dirname(__FILE__) + '/lib/ebay_trading')
  end
end

Rake::RDocTask.new { |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "eBayAPI Ruby client for the eBay unified schema XML API"
  rdoc.options << '--line-numbers' << '--inline-source' << '--main=README'
  rdoc.rdoc_files.include('README', 'CHANGELOG')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.exclude('lib/ebay_trading/schema')
  rdoc.rdoc_files.exclude('lib/support')
}