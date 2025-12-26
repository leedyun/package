namespace :endpoint_flux do
  desc 'Initialize project with endpoint_flux'
  task :init  => :environment do
    require 'fileutils'
    puts 'Creating files...'
    path = File.expand_path(__dir__)
    FileUtils.cp_r "#{path}/generators/endpoint_flux", 'app/endpoint_flux'
    FileUtils.cp "#{path}/generators/initializers/endpoint_flux.rb", 'config/initializers/endpoint_flux.rb'
    puts 'Finished'
  end
end

