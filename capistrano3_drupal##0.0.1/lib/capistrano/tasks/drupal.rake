namespace :deploy do

  desc 'Clear all Drupal caches'
  task :clear_cache do
    on roles :app do
      within release_path do
        execute :drush, 'cc all'
      end
    end
  end

  after :publishing, :clear_cache

end
