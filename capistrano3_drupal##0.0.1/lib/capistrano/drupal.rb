require "capistrano/drupal/drupal"

namespace :load do
  task :defaults do
    load 'capistrano/drupal/defaults.rb'
  end
end
