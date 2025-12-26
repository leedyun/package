require 'capistrano'

require 'capistrano-logs/version'
require 'capistrano-logs/capistrano_integration'

module CapistranoLogs
  class CapistranoIntegration
    def self.load_into(capistrano_config)
      capistrano_config.load do
        namespace :logs do
          desc "Tail log files across all ROLE instances"
          task :tail, :roles => ENV['ROLE'] || :web do
            last_host = ""
            max_hostname_length=19
            run "tail -f #{shared_path}/log/#{rails_env}.log" do |channel, stream, data|
              trap("INT") { puts 'Interupted'; exit 0; }
              tag = channel[:host].split(".").first
              tag += " "*(max_hostname_length-tag.length) + ":  "
              data.strip!
              data.gsub! /\n/, "\n#{tag}"
              puts tag if channel[:host] != last_host
              puts "#{tag}#{data}"
              last_host = channel[:host]
              break if stream == :err
            end
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  CapistranoLogs::CapistranoIntegration.load_into(Capistrano::Configuration.instance)
end
