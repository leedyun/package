# LogsViewer

This gem was developed to make possible the visualization of the application logs in the browser.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'logs_viewer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logs_viewer

## Configuration (Rails)

Create file **config/initializers/logs_viewer.rb** with the following content:
```ruby
LogsViewer::Config.number_lines = 1000
LogsViewer::Config.log_dir = "log"
```

Add the hack on their application in the file **config/application.rb**
```ruby
module YourApplicationModule
  class Application < Rails::Application

    # Rack to intercept path /logs
    config.middleware.use LogsViewer::Display
  end
end

```

## Usage

After creating the initialization file and add the rack, go to your project the path /logs: (http://your-app:port/logs)

#### Example display
![gem-logs-viewer.png](https://bitbucket.org/repo/rbj7zp/images/2284852797-gem-logs-viewer.png)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/logs_viewer.

