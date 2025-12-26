# Tanuki Emoji

This library helps you implement Emoji support in a ruby application by providing you access to native Emoji character
information.

We currently provide a pre-indexed set of Emojis, based on the
[Unicode 15.1 emojis](https://unicode.org/Public/emoji/15.1/emoji-test.txt).
Backward compatibility is maintained with [Gemojione](https://github.com/bonusly/gemojione)
index from 3.3.0.

This gem bundles Emoji assets from [Noto Emoji](https://github.com/googlefonts/noto-emoji), to be used as fallback when
Emoji is not available or not fully supported on target system.

## Development dependencies

Install [cairo](https://cairographics.org/) on your local machine.

```shell
# For osx users

$ brew install cairo
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tanuki_emoji'
```

And then execute:

```shell
$ bundle install
```

## Usage

To access the index and list all known Emoji Characters:

```ruby
TanukiEmoji.index.all
```

To search for an Emoji by it's codepoints (the unicode character):

```ruby
# Find by providing the Emoji Character itself
TanukiEmoji.find_by_codepoints('🐴')
#=> #<TanukiEmoji::Character:horse 🐴(1f434)>

# Find by providing a string representation of the hexadecimal of the codepoint:
TanukiEmoji.find_by_codepoints("\u{1f434}")
#=> #<TanukiEmoji::Character:horse 🐴(1f434)>
```

To search for an Emoji by it's `:alpha_code:`

```ruby
# Find by providing the :alpha_code:
TanukiEmoji.find_by_alpha_code(':horse:')
#=> #<TanukiEmoji::Character:horse 🐴(1f434)>

# It also accepts a `shortcode` (an alpha_code not surrounded by colons)
TanukiEmoji.find_by_alpha_code('horse')
#=> #<TanukiEmoji::Character:horse 🐴(1f434)>
```

To retrieve an alternative image for the character:
```ruby
c = TanukiEmoji.find_by_alpha_code('horse')
#=> #<TanukiEmoji::Character:horse 🐴(1f434)>

c.image_name
#=> "emoji_u1f434.png"

# Use the image_name with bundled assets from Noto Emoji:
File.join(TanukiEmoji.images_path, c.image_name)
#=> "/path/to/tanuki_emoji/app/assets/images/tanuki_emoji/emoji_u1f434.png"
```

## Development

In order to contribute to TanukiEmoji gem, you need to:

1. Clone the repository to your local machine.
1. Run `bin/setup` to initialize `git submodules` and install ruby dependencies.

Many workflow tasks are available as Rake tasks:

- `bundle exec rake spec` can be used to run tests.
- `bundle exec rake install` will build and install the gem on your local machine.

To load an interactive console with the gem you can use `bin/console`.

### Releasing a new version

Before releasing a new gem, create a MR with the following changes:

- Update the version number in `lib/tanuki_emoji/version.rb`.
- Run `bundle install` to update `Gemfile.lock` and commit it.
- Ensure that `CHANGELOG.md` is updated by the project bot in the MR.

With that MR approved and merged, a [CI job](https://gitlab.com/gitlab-org/components/gem-release):
- Creates a [new release](https://gitlab.com/gitlab-org/ruby/gems/tanuki_emoji/-/releases)
- Generates the changelog on the release page
- Publishes new gem into [rubygems.org](https://rubygems.org)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) and [Development](#development) section.

When you create a new Merge Request with a new feature, a feature change, or a fix, consider adding a changelog entry
using a [Git trailer](https://docs.gitlab.com/ee/api/repositories.html#how-it-works), for example `Changelog: added`.

You may use the [following values](.gitlab/changelog_config.yml):

- `added` for new features.
- `changed` for changes in existing functionality.
- `deprecated` for soon-to-be removed features.
- `removed` for now removed features.
- `fixed` for any bug fixes.
- `security` in case of vulnerabilities.

Please do not increase the version numbers, as this is handled by a separate process when we [release a new version](#releasing-a-new-version).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

Noto Emoji assets and build tools are [Apache license, version 2.0](https://github.com/googlefonts/noto-emoji/blob/main/LICENSE)
licensed.

Flag images are under
public domain or otherwise exempt from copyright
([more info](https://github.com/googlefonts/noto-emoji/blob/main/third_party/region-flags/LICENSE)).
