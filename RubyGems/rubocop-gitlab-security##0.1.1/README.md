This is an early attempt at creating Rubocop rules, similar to Rubocop-RSpec, for
blocking dangerous code. This code is based heavily upon the [Rubocop-RSpec](https://github.com/backus/rubocop-rspec)
code released under the MIT License.

## Installation

Just install the `rubocop-gitlab-security` gem

```bash
gem install rubocop-gitlab-security
```

or if you use bundler put this in your `Gemfile`

```
gem 'rubocop-gitlab-security'
```


## Usage

You need to tell RuboCop to load the Gitlab-Security extension. There are three
ways to do this:

### RuboCop configuration file

Put this into your `.rubocop.yml`.

```
require: rubocop-gitlab-security
```

Now you can run `rubocop` and it will automatically load the RuboCop Gitlab-Security
cops together with the standard cops.

### Command line

```bash
rubocop --require rubocop-gitlab-security
```

### Rake task

```ruby
RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-gitlab-security'
end
```

## Inspecting specific files

By default, `rubocop-gitlab-security` inspects all files. You can override this setting in your config file by specifying one or more patterns:

```yaml
# Inspect all files
AllCops:
  GitlabSecurity:
    Patterns:
    - '.+'
```

```yaml
# Inspect only controller files.
AllCops:
  GitlabSecurity:
    Patterns:
    - app/controllers/**/*.rb
```

## The Cops

All cops are located under
[`lib/rubocop/cop/gitlab-security`](lib/rubocop/cop/gitlab-security), and contain
examples/documentation.

In your `.rubocop.yml`, you may treat the Gitlab-Security cops just like any other
cop. For example:

```yaml
GitlabSecurity/PublicSend:
  Exclude:
    - 'spec/**/*'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Merge Request

## License

`rubocop-gitlab-security` is MIT licensed. [See the accompanying file](MIT-LICENSE.md) for
the full text.
