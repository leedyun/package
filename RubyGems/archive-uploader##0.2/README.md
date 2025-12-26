# ArchiveUploader

Compress a list of files/directories and uploads them to an url, accompanied by git metadata (branch, last commit timestamp, last commit author and last commit hash). Currently made to be used for [stat_fu](http://github.com/kuende/stat_fu).

## Installation

Add this line to your application's Gemfile:

    gem 'archive_uploader', '~> 0.1.0'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install archive_uploader

## Usage

```bash
$ ARCHIVE_UPLOADER_URL="http://your.url/path" archive_uploader coverage/ brakeman/
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
