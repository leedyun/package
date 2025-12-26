# Fluent Logsene Plugin
[Fluentd](http://fluentd.org) output plugin for [Logsene](http://sematext.com/logsene).

## Installation
Add this line to your application's Gemfile:

    gem 'fluent-plugin-logsene'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-logsene

## Usage
Simply replace the dummy application token in the `path` configuration setting with the one you can find on the `App Actions > App Settings` or the `Integration` page when you sign in on [https://apps.sematext.com](https://apps.sematext.com).  
Of course, you should customize the match regex to include your logs of choice.

      <match *.syslog.*>
        type logsene
        path /5233x41x-3xx5-8754-x354-xxx1x018ex33x
      </match>

It's that simple!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
