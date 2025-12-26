# AssetPipeline

Add Sprockets based Asset Pipeline to your Ruby applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'asset_pipeline'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install asset_pipeline

## Usage

```ruby
# config/initializers/assets.rb
# 

require 'asset_pipeline'

AssetPipeline.config do |config|
  # Your public directory.
  # Default: 'public'
  #
  config.public_folder = 'custom'

  # Which assets to precompile.
  # Default: %w(application.js application.css *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2)
  #
  config.assets_precompile = %w(vendor_script.js)
  
  # Where to get assets from for compilation.
  # Default: %w(assets vendor/assets)
  #
  config.assets_paths  = %w(apps/web/assets vendor)
  
  # Which protocol to use to generate asset paths.
  # Default: 'http://'
  #
  config.assets_protocol = :https
  
  # Sets assets compressors.
  # See more at https://github.com/rails/sprockets#minifying-assets
  # Default: nil
  #
  config.assets_css_compressor = :scss
  config.assets_js_compressor  = :uglify
  
  # Link to assets from a dedicated server (e.g. CloudFront)
  # Default: nil.
  #
  config.assets_host = 'example.com'
  
  # Use digests?
  # Default: false.
  #
  config.assets_digest = false
  
  # Debug mode? Useful for development.
  # Default: false
  #
  config.assets_debug  = true
end

# Rakefile
#

require_relative 'config/initializers/assets'

# This adds assets:clean and assets:precompile tasks
AssetPipeline::Tasks.install

# config.ru
#

map "#{AssetPipeline.path_prefix}" do
  run AssetPipeline.sprockets
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/asset_pipeline.
