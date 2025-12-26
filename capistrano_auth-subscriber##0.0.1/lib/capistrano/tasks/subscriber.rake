namespace :subscriber do
  desc 'Start subscriber'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rake subscriber:start"
        end
      end
    end
  end

  desc 'Stop subscriber'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rake subscriber:stop"
        end
      end
    end
  end

  desc 'Restart subscriber'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rake subscriber:restart"
        end
      end
    end
  end
end
