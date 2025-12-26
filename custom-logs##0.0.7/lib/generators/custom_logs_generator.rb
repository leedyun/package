class CustomLogsGenerator < Rails::Generators::Base

  source_root File.expand_path("../templates", __FILE__)
  argument :syslog, type: :string, default: 'false'

  desc 'Creating config file for redis logstash'
  def config
    template "custom_logs.yml", 'config/custom_logs.yml'
  end

  private

  def user_methods
    user_methods = ApplicationController.new.methods.select{|m| m.to_s.starts_with?('current_')}
  end

  def syslog?
    return true if syslog == true || syslog =~ (/(true|t|yes|y|1|syslog)$/i)
    return false
  end

end