Capistrano::Configuration.instance.load do
  namespace :auto_cron do
    task :publish, :roles => :publish do
      @config_dir = File.join release_path, "config", "auto_cron"
      run "cd #{release_path} && #{rake} TEMPLATES=#{fetch(:auto_cron_templates, %w( publish )).join(",")} APPLICATION=#{application} RAILS_ENV=#{rails_env} CONFIG_AUTO_CRON=#{@config_dir} auto_cron"
    end
  end
end