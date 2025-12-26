require File.dirname(__FILE__) + "/../auto_cron"

desc "Generates the auto-cron and saves it to the crontab"
task :auto_cron do
  require 'tempfile'
  auto_cron = AutoCron.new ENV['TEMPLATES'], ENV['APPLICATION']
  cron_body = auto_cron.updated_crontab
  tmp_cron_path = Tempfile.new( 'auto_cron' ).path
  File.open( tmp_cron_path, File::WRONLY | File::APPEND ) do |file|
    file << cron_body
  end
  sh "crontab #{ tmp_cron_path }"
end