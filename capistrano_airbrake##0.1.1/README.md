# Capistrano::Airbrake

Airbrake integration for Capistrano.
Easy deploy notification for your Airbrake / Errbit.

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano', '~> 3.0'
    gem 'capistrano-airbrake'

And then execute:

    $ bundle

## Usage

Require in Capfile to use the default task:

    # Capfile
    require 'capistrano/rvm'

And you should be good to go!
After `deploy:restart` the task `airbrake:notify_deploy` will be executed.

## Coniguration

Everything *should work* out of the box.

If you need some special settings, set those in the stage file for your server:

    # deploy.rb or stage file (staging.rb, production.rb or else)
    set :airbrake_args,         ->{ "TO=#{fetch(:stage)} REVISION=#{fetch(:airbrake_revision)} REPO=#{fetch(:repo_url)}"  }
    set :airbrake_environment,  ->{ fetch :rails_env, "production"   }
    set :airbrake_revision,     ->{ fetch :current_revision, "none"  }
    set :airbrake_roles,        ->{ :app  }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
