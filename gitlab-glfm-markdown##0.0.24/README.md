# GitLab Flavored Markdown

[![Pipeline status](https://gitlab.com/gitlab-org/ruby/gems/gitlab-glfm-markdown/badges/main/pipeline.svg)](https://gitlab.com/gitlab-org/ruby/gems/gitlab-glfm-markdown/-/commits/main)
[![Latest Release](https://gitlab.com/gitlab-org/ruby/gems/gitlab-glfm-markdown/-/badges/release.svg)](https://gitlab.com/gitlab-org/ruby/gems/gitlab-glfm-markdown/-/releases)

Implements GLFM (as used by GitLab) using the Rust-based markdown parser [comrak](https://github.com/kivikakk/comrak)
and providing a Ruby interface.\
_Currently using `comrak 0.31.0`_.

This project is still in constant flux, so interfaces and functionality can change at any time.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add gitlab-glfm-markdown

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install gitlab-glfm-markdown

## Usage

Try on command line:

```
rake compile
bin/console

GLFMMarkdown.to_html('# header', options: { sourcepos: true })
```

### Options

| Option name                     | Description                                                                           |
|---------------------------------|---------------------------------------------------------------------------------------|
| `autolink`                      | Enable the `autolink` extension                                                       |
| `description_lists`             | Enable the `description-lists` extension                                              |
| `escape`                        | Escape raw HTML instead of clobbering it                                              |
| `escape_char_spans`             | Wrap escaped characters in a `<span>` to allow any post-processing to recognize them  |
| `figure_with_caption`           | Render the image as a figure element with the title as its caption                    |
| `footnotes`                     | Enable the `footnotes` extension                                                      |
| `full_info_string`              | Enable full info strings for code blocks                                              |
| `gemojis`                       | Enable the `gemojis` extensions - translate gemojis into UTF-8 characters             |
| `gfm_quirks`                    | Enables GFM-style quirks in output HTML, such as not nesting <strong> tags            |
| `github_pre_lang`               | Use GitHub-style `<pre lang>` for code blocks                                         |
| `greentext`                     | Enable the `greentext` extension - requires at least one space after a `>` character to generate a blockquote, and restarts blockquote nesting across unique lines of input |
| `hardbreaks`                    | Treat newlines as hard line breaks                                                    |
| `header_ids <PREFIX>`           | Enable the `header-id` extension, with the given ID prefix                            |
| `ignore_empty_links`            | Ignore empty links in input                                                           |
| `ignore_setext`                 | Ignore setext headings in input                                                       |
| `math_code`                     | Enables `math code` extension, using math code syntax                                 |
| `math_dollars`                  | Enables `math dollars` extension, using math dollar syntax                            |
| `multiline_block_quotes`        | Enable the `multiline-block-quotes` extension                                         |
| `relaxed_autolinks`             | Enable relaxing of autolink parsing, allowing links to be recognized when in brackets |
| `relaxed_tasklist_character`    | Enable relaxing which character is allowed in tasklists                               |
| `sourcepos`                     | Include source mappings in HTML attributes                                            |
| `experimental_inline_sourcepos` | Include inline sourcepos in HTML output, which is known to have issues                |
| `smart`                         | Use smart punctuation                                                                 |
| `spoiler`                       | Enable the `spoiler` extension - use double vertical bars                             |
| `strikethrough`                 | Enable the `strikethrough` extension                                                  |
| `superscript`                   | Enable the `superscript` extension                                                    |
| `table`                         | Enable the `table` extension                                                          |
| `tagfilter`                     | Enable the `tagfilter` extension                                                      |
| `tasklist`                      | Enable the `tasklist` extension                                                       |
| `underline`                     | Enables the `underline` extension - use double underscores                            |
| `unsafe`                        | Allow raw HTML and dangerous URLs                                                     |
| `wikilinks_title_after_pipe`    | Enable the `wikilinks_title_after_pipe` extension                                     |
| `wikilinks_title_before_pipe`   | Enable the `wikilinks_title_before_pipe` extension                                    |
| `debug`                         | Show debug information                                                                |

## Dingus / Demo

A demo is running via GitLab Pages, and can be accessed at:

https://gitlab-org.gitlab.io/ruby/gems/gitlab-glfm-markdown

## Development

A command line executable can be built for debugging.

```
cargo run --bin glfm_markdown --features="cli" -- --help
cargo run --bin glfm_markdown --features="cli" -- --sourcepos
```

There is a VSCode workspace that allows you to `Debug executable`

When developing another project locally and using `gitlab-glfm-markdown` by linking
directly to the gem's source directory, make sure that you're using the same version
of Ruby for the project and the gem. Otherwise you can see unexplained errors when
calling into the gem.

NOTE: This project generates a changelog automatically that gets attached to the release entry.
The normal [GitLab changelog entry process](https://docs.gitlab.com/ee/development/changelog.html)
should be followed.

### Releasing a new version

To release a new version, create a merge request and use the `Release` template, following it's instructions.

Once merged, the new version with precompiled, native gems will automatically be
published to [RubyGems](https://rubygems.org/gems/gitlab-glfm-markdown).

## Contributing

Bug reports and merge requests are welcome on GitLab at https://gitlab.com/gitlab-org/ruby/gems/gitlab-glfm-markdown.

Please refer to [CONTRIBUTING](CONTRIBUTING.md) for more details.
