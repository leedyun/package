# AssetLink

This gem allows to replace any asset (image, CSS stylesheet, script, etc.) with a light-weight link to the same asset located at a remote storage (e.g. Amazon S3).
The idea behind it is to reduce the size of the application deployment, especially when it is limited by a hosting service (e.g. max slug size at Heroku is 300MB).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'asset_link'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install asset_link

## Usage

### Upload

To upload asset(s) to the remote storage run:

    $ asset_link_upload [FILE_PATTERN]

e.g. to upload all .jpg images from /app/assets folder run:

    $ cd ./app
    $ asset_link_upload ./assets/**/*.jpg

As a result each image.jpg file would be uploaded to the remote storage and replaced by a text file image.jpg.link that contains a link to that remote file.

### Download

To download asset(s) from the remote storage run:

    $ asset_link_download [FILE_PATTERN]

e.g. to replace all .jpg.link images by originals in /app/assets folder run:

    $ cd ./app
    $ asset_link_upload ./assets/**/*.jpg.link

As a result each image.jpg.link file would be replaced by the original image.jpg file from the remote storage.

### Middleware

In order to allow Rails server to respond with original asset content from .link file, install middleware:

in config.ru add before ``run Rails.application``:

```ruby
use AssetLink::Middleware
```

in config/initializers/sprokets.rb:

```ruby
Sprockets.register_engine '.link', AssetLink::Processor.new, silence_deprecation: true
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/doubleton/asset_link.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

