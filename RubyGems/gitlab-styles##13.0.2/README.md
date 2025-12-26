# Gitlab::Styles

`Gitlab::Styles` centralizes some shared GitLab's styles config (only RuboCop
for now), as well as custom RuboCop cops.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gitlab-styles', require: false
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gitlab-styles

## Usage

### Inherit all rules

Include the following in your `.rubocop.yml` and remove all the rules that are
already in `rubocop-default.yml`:

```yaml
inherit_gem:
  gitlab-styles:
    - rubocop-default.yml
```

### Inherit only some kind of rules

The rules are grouped by type so you can choose to inherit only some kind of
rules:

- `rubocop-all.yml`
- `rubocop-bundler.yml`
- `rubocop-gemspec.yml`
- `rubocop-layout.yml`
- `rubocop-lint.yml`
- `rubocop-migrations.yml`
- `rubocop-metrics.yml`
- `rubocop-naming.yml`
- `rubocop-performance.yml`
- `rubocop-rails.yml`
- `rubocop-rspec.yml`
- `rubocop-security.yml`
- `rubocop-style.yml`
- `rubocop-tailwind.yml`

Example:

```yaml
inherit_gem:
  gitlab-styles:
    - rubocop-gemspec.yml
    - rubocop-naming.yml
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To test some rules locally, there is a test application [in the playground folder](./playground/). It is a vanilla Rails 6 application with your local `gitlab-styles` included, and it is used to test RuboCop rules. You can add code in it (preferably RuboCop offenses) and run the following command to test the RuboCop policy we setup:

```shell
cd playground
bundle install
bundle exec rubocop -c .rubocop.yml
```

### Activate lefthook locally

```shell
lefthook install
```

## Release Process

We release `gitlab-styles` on an ad-hoc basis. There is no regularity to when
we release, we just release when we make a change - no matter the size of the
change.

To release a new version:

1. Create a Merge Request.
1. Use Merge Request template [Release.md](https://gitlab.com/gitlab-org/ruby/gems/gitlab-styles/-/blob/master/.gitlab/merge_request_templates/Release.md).
1. Follow the instructions.
1. After the Merge Request has been merged, a new gem version is [published automatically](https://gitlab.com/gitlab-org/components/gem-release).
1. Once the new gem version is visible on [RubyGems.org](https://rubygems.org/gems/gitlab-styles), it is recommended to update [GitLab's `Gemfile`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/Gemfile) to bump the `gitlab-styles` Ruby gem to the new version also.

See [!123](https://gitlab.com/gitlab-org/ruby/gems/gitlab-styles/-/merge_requests/123) as an example.

## Contributing

Bug reports and merge requests are welcome on GitLab at
https://gitlab.com/gitlab-org/gitlab-styles. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to adhere
to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `Gitlab::Styles` project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](https://gitlab.com/gitlab-org/gitlab-styles/blob/master/CODE_OF_CONDUCT.md).
