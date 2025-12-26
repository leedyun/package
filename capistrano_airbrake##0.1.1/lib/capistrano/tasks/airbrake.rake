namespace :airbrake do
  desc 'Notify airbrake of deploy.'
  task :notify_deploy do
    on roles fetch(:airbrake_roles) do
      within release_path do
        with rails_env: fetch(:airbrake_environment) do
          execute :rake, "airbrake:deploy", fetch(:airbrake_args)
        end
      end
    end
  end # -- task :notify_deploy

  after 'deploy:restart', 'airbrake:notify_deploy'
end # -- namespace :airbrake

namespace :load do
  task :defaults do
    set :airbrake_args,         ->{ "TO=#{fetch(:stage)} REVISION=#{fetch(:airbrake_revision)} REPO=#{fetch(:repo_url)}" }
    set :airbrake_environment,  ->{ fetch :rails_env, "production"  }
    set :airbrake_revision,     ->{ fetch :current_revision, "none" }
    set :airbrake_roles,        ->{ :app }
  end # -- task :defaults
end # -- namespace :load
