# LabKit-Ruby 🔬🔬🔬🔬🔬

LabKit-Ruby is minimalist library to provide functionality for Ruby services at GitLab.

LabKit-Ruby is the Ruby companion for [LabKit](https://gitlab.com/gitlab-org/labkit), a minimalist library to provide functionality for Go services at GitLab.

LabKit-Ruby and LabKit are intended to provide similar functionality, but use the semantics of their respective languages, so are not intended to provide identical APIS.

## Documentation

API Documentation is available at [the Rubydoc site](https://www.rubydoc.info/gems/gitlab-labkit/).

## Changelog

The changelog is available via [**tagged release notes**](https://gitlab.com/gitlab-org/labkit-ruby/tags)

## Functionality

LabKit-Ruby provides functionality in a number of areas:

1. `Labkit::Context` used for providing context information to log messages.
1. `Labkit::Correlation` For accessing the correlation id. (Generated and propagated by `Labkit::Context`)
1. `Labkit::FIPS` for checking for FIPS mode and using FIPS-compliant algorithms.
1. `Labkit::Logging` for sanitizing log messages.
1. `Labkit::Tracing` for handling and propagating distributed traces.

## Developing

Anyone can contribute!

```console
$ git clone git@gitlab.com:gitlab-org/labkit-ruby.git
$ cd labkit-ruby
$ bundle install

$ # Autoformat code and auto-correct linters
$ bundle exec rake fix

$ # Run tests, linters
$ bundle exec rake verify
```

Note that LabKit-Ruby uses the [`rufo`](https://github.com/ruby-formatter/rufo) for auto-formatting. Please run `bundle exec rake fix` to auto-format your code before pushing.

Please also review the [development section of the LabKit (go) README](https://gitlab.com/gitlab-org/labkit#developing-labkit) for details of the LabKit architectural philosophy.

To work on some of the scripts we use for releasing a new version,
make sure to add a new `.env.sh`.

```console
cp .env.example.sh .env.sh`
```

Inside `.env.sh`, add a personal acccess token for the `GITLAB_TOKEN`
environment variable. Next source the file:

```console
. .env.sh
```

### Releasing a new version

Releasing a new version can be done by pushing a new tag, or creating
it from the
[interface](https://gitlab.com/gitlab-org/labkit-ruby/-/tags).

A new changelog will automatically be added to the release on Gitlab.

The new version will automatically be published to `gitlab-labkit` on
[rubygems](https://rubygems.org/gems/gitlab-labkit) when the pipeline
for the tag completes. It might take a few minutes before the update
is available.

A gem called [`labkit-ruby`](https://rubygems.org/gems/labkit-ruby) is
also published to RubyGems.org as a placeholder. The same bot that
pushes this gem has access.
