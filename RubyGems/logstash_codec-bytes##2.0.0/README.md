# logstash-codec-bytes

[![Build Status](https://travis-ci.org/lob/logstash-codec-bytes.svg?branch=master)](https://travis-ci.org/lob/logstash-codec-bytes)
[![Gem Version](https://badge.fury.io/rb/logstash-codec-bytes.svg)](http://badge.fury.io/rb/logstash-codec-bytes)
[![Coverage Status](https://coveralls.io/repos/github/lob/logstash-codec-bytes/badge.svg?branch=master)](https://coveralls.io/github/lob/logstash-codec-bytes?branch=master)

Logstash codec plugin to chunk an input into an event every specified number of bytes.

## About

This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is MIT, meaning you are pretty much free to use it however you want in whatever way.

### Installation

#### Code
- To get started, you'll need JRuby with the Bundler gem installed.

- Install dependencies
```sh
bundle install
```

#### Test

- Update your dependencies

```sh
$ bundle install
```

- Run tests

```sh
$ bundle exec rspec
```

### Running the Plugin in Logstash (version 2.3.x)

- Install the plugin

```sh
bin/logstash-plugin install logstash-codec-bytes
```

- Run Logstash with the plugin

```sh
bin/logstash -e 'input { file { path => "/path/to/file" delimiter => "" codec => bytes { length => X } } }'
```
where length X is the number of bytes you want to read before emitting an event.

Note: we recommend sending smaller, more frequent events into the bytes codec for the best performance. With the file input plugin above, we set the delimiter to "" because otherwise it defaults to emitting an event every \n character. If a file were only one line, the entire file would be fed into the bytes codec, leading to reduced performance.

## Contributing

Make sure you have JRuby and Bundler installed. Copy and paste the following commands in your projects directory.

    git clone https://github.com/lob/logstash-codec-bytes.git
    cd logstash-codec-bytes
    bundle install

### Contributing Instructions

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Make sure the tests pass
6. Open up coverage/index.html in your browser and add tests if required
7. Create new Pull Request

=======================

Copyright &copy; 2016 Lob.com

Released under the MIT License, which can be found in the repository in `LICENSE`.
