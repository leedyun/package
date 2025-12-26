# 99designs Tasks

99designs Tasks API client for Ruby

[![Build Status](https://travis-ci.org/99designs/tasks-api-ruby.svg)](https://travis-ci.org/99designs/tasks-api-ruby)

## Installation

Add this line to your application's Gemfile:

    gem '99designs-tasks'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install 99designs-tasks

## Usage

Simple usage looks like:

```ruby
require '99designs/tasks'
api = NinetyNine::ApiClient.new('yourapikey')
task = api.create_task body: 'hello', filenames: ['/path/to/file.pdf'], urls: ['http://example.org/file.png']
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/99designs-tasks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
