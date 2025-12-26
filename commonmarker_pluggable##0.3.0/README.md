[![Gem Version][badge-img]][badge-link]

[badge-img]: https://badge.fury.io/rb/commonmarker-pluggable.svg
[badge-link]: https://badge.fury.io/rb/commonmarker-pluggable

# commonmarker-pluggable

commonmarker-pluggable adds support for plugins to CommonMarker.

The `cmark` reference parser used by CommonMarker supports extensions to the
CommonMark specification but these are written in C. The commonmarker-pluggable
plugin allows users to extend CommonMarker's parsing capabilities with plugins
written in Ruby.

## Installation

The commonmarker-pluggable plugin requires the commonmarker plugin to
be installed and configured ([instructions here][cmp]). The only additional
step is to add commonmarker-pluggable to your `Gemfile` like so:

[cmp]: https://github.com/gjtorikian/commonmarker

```ruby
gem 'commonmarker'
gem 'commonmarker-pluggable'
```

## Writing Plugins

Once commonmarker-pluggable is installed, you can add plugins that manipulate
the Markdown document parsed by `cmark`.

Plugins are automatically detected by commonmark-pluggable if they are within
the `Commonmarker::Plugin` namespace as demonstrated below. Please note that the
plugin itself must be of type `Module`.

A plugin must implement the `self.call()` module method. This method takes one
argument: `doc`. This is a `CommonMarker::Node` object representing the
top-most node of a parsed Markdown document.

An example plugin is set out below:

```ruby
module CommonMarker
  module Plugin
    module Example
      def self.call(doc)
        doc.walk do |node|
          node.delete if node.string_content == 'To be deleted'
        end
      end
    end
  end
end
```

## Using with Jekyll

commonmarker-pluggable was originally written for use with Jekyll. If you want
to write a plugin that is both a CommonMarker plugin _and_ a Jekyll plugin, you
need to ensure that commonmarker-pluggable is installed as a Jekyll plugin.
There are [other ways][jk-pl] to do this, but the easiest method is to include
commonmarker-pluggable in the `:jekyll_plugins` group in your Gemfile:

[jk-pl]: https://jekyllrb.com/docs/plugins/installation/

```ruby
group :jekyll_plugins do
  gem 'commonmarker-pluggable'
  gem 'jekyll-commonmark'
  ...
end
```

## Bugs

Found a bug? I'd love to know about it. The best way is to report them in the
[Issues section][gh-i] on GitHub.

[gh-i]: https://github.com/pyrmont/commonmarker-pluggable/issues

## Contributing

If you're interested in contributing to commonmarker-pluggable, feel free to
fork and submit a pull request.

## Versioning

The commonmarker-pluggable plugin uses [Semantic Versioning 2.0.0][sv2].

[sv2]: http://semver.org/

## Licence

The commonmarker-pluggable plugin is released into the public domain. See
[LICENSE.md][lc] for more details.

[lc]: https://github.com/pyrmont/commonmarker-pluggable/blob/master/LICENSE.md
