## 1.9.0 (2023-01-11)

* [Add support for docutils 0.19, remove support for 0.14/0.15](https://gitlab.com/gitlab-org/gitlab-markup/-/merge_requests/42)


## 1.8.1 (2022-09-16)

* [Fix compatibility with Busybox timeout](https://gitlab.com/gitlab-org/gitlab-markup/-/merge_requests/37)

## 1.8.0 (2021-12-02)

* Disable configuration file processing in RST
* Wrap call to rest2html in a timeout

## 1.7.1 (2020-05-01)

* Fix RST rendering not working for large files

## 1.7.0 (2019-03-05)

* Require Python 3

## 1.6.5 (2018-10-31)

* Renamed executable from `github-markup` to `gitlab-markup`

## 1.6.4 (2018-06-08)

* Fixed extra blank line at start of rendered reStructuredText code block

## 1.6.3 (2017-10-30)

* Support PlantUML caption option and `uml::` directive

## 1.6.2 (2017-09-20)

* Support PlantUML blocks in reStructuredText

## 1.6.0 (2017-05-01)

* Updated docutils support (now requires 0.13.1)

## 1.5.1 (2017-01-09)

* Disable rendering from `.. raw::` content block

## 1.5.0 (2016-10-13)

* GitLab CI support
* Fixed `.pod` test files to use newer syntax.
* Changes to support Python 3 (it's not out-of-the box yet, you still need to patch code)
* Gem published as 'gitlab-markup'

## 1.3.3 (2015-02-17)

* Address a slight typo with `POSIX` [#456](https://github.com/github/markup/pull/456)

[Full changelog](https://github.com/github/markup/compare/v1.3.2...v1.3.3)

## 1.3.2 (2015-02-17)

* RST: Output code instead of tt for inline literals [#370](https://github.com/github/markup/pull/370)
* RST: Add IDs to headers so that `.. contents` works with `.. sectnum` [#391](https://github.com/github/markup/pull/391)

[Full changelog](https://github.com/github/markup/compare/v1.3.1...v1.3.2)

## 1.3.1 (2014-11-13)

* Fix name error when trying to use newer versions of RedCarpet [#387](https://github.com/github/markup/pull/387)

[Full changelog](https://github.com/github/markup/compare/v1.3.0...v1.3.1)

## 1.3.0 (2014-09-11)

* Extend the field limit for tables to 50 characters for RST [#306](https://github.com/github/markup/pull/306)
* Add `.mkdn` as a supported markdown extension [#308](https://github.com/github/markup/pull/308)
* Upgrade wikicloth to 0.8.1 [#317](https://github.com/github/markup/pull/317)
* Force encoding of posix-spawn output [#338](https://github.com/github/markup/pull/338)
* Add `.rmd` as a supported markdown extension [#343](https://github.com/github/markup/pull/343)

[Full changelog](https://github.com/github/markup/compare/v1.2.1...v1.3.0)

## 1.2.1 (2014-04-23)

* Disable RST warnings [#290](https://github.com/github/markup/pull/290)

[Full changelog](https://github.com/github/markup/compare/v1.2.0...v1.2.1)

## 1.1.1 (2014-04-03)

* Upgrade to org-ruby 0.9.1
* Set default encoding to UTF-8 for Python 2

## 1.1.0 (2014-03-10)

* Raise GitHub::Markup::CommandError if external command exits with a non-zero status.
* Remove support for literate Haskell (see #266)

## 0.5.1 (2010-09-30)

* Support relative path links in rdoc

## 0.5.0 (2010-07-07)

* Added creole support

## 0.4.0 (2010-04-23)

* Removed man page support until it's ready.

## 0.3.3 (2010-03-29)

* UTF-8 works with ReST now.

## 0.3.2 (2010-03-25)

* Improved test runner
* Forgive ReST problems that aren't user errors.

## 0.3.1 (2010-03-22)

* Add .rst.txt extension
* Fix ASCII encoding error while using print u'\u010c' non-ASCII char and similar.

## 0.3.0 (2010-03-11)

* man rendering
* `github-markup` command line runner

## 0.2.2 (2010-02-09)

* pod fixes from Ricardo Signes

## 0.2.1 (2010-01-25)

* ReST fixes from Michael Jones

## 0.2.0 (2010-01-10)

* org-mode support

## 0.1.7 (2009-11-17)

* Ditch asciidoc2html, call asciidoc directly

## 0.1.6 (2009-11-17)

* mdown

## 0.1.5 (2009-11-17)

* Actually, if we can't render a thing then don't. Not once, not never.

## 0.1.4 (2009-11-17)

* Bugfix: Missing commands return the input (instead of nothing)

## 0.1.3 (2009-11-02)

* Strip the INDEX comments from POD

## 0.1.2 (2009-11-02)

* Renamed to `github-markup`
* Bugfix: POD rendering works now, not just index

## 0.1.1 (2009-11-02)

* Added `GitHub::Markup.can_render?` helper.
* Bugfix: Actually check file extensions

## 0.1.0 (2009-11-02)

* First release
