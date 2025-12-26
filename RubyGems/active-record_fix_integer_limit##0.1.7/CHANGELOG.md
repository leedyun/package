# ChangeLog

Here's an overview of notable changes to this program.  
For more technical details, try [`tig`](https://jonas.github.io/tig/).

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Nothing yet. Maybe open an issue?

## [0.1.7] - 2018-09-18

No functionality change.

Brain, remember to update those Markdown links to compare view...

## [0.1.6] - 2018-09-18

No functionality change.

BTW, step 4 and 6 below are completely useless, as they are taken care of by
`bundle exec rake release`. OK, enough for today. You can resume your normal
activity, that is functional, efficient, professional, and probably boring.

Release a new version of your gem:

1. Bump version
2. run `bundle install` (now the `Gemfile.lock` is updated to the right version)
3. commit changes
4. run `bundle exec rake release`

## [0.1.5] - 2018-09-18

No functionality change.

Ha! Is this a new form of blogging?

So you know because you're reading this before previous releases, it also serve
as a "Rubygems Caveats 101". Go, go learn! I'm so stupid sometimes. But my mind,
hopefully, now has done all the beginner's mistakes related to releasing
rubygems. Heh.

## [0.1.4] - 2018-09-18

No functionality change.

Now I know:
1. Bump version
2. run `bundle install` (now the `Gemfile.lock` is updated to the right version)
3. commit changes
4. `git push`
5. run `bundle exec rake release`
6. `git push --tags`

OK, that was to document my rubygems making discovery. Now I'll use branches to
make such experiments and not bother you with them. Yet this documentation might
become useful to people like me who are clueless and do not get gem tutorials
the first time.

## [0.1.3] - 2018-09-18

No functionality change.

## [0.1.2] - 2018-09-18

No functionality change.

### Changed
- Last two releases were to fix relative links to the compare view so that it
  works across Gitlab and Github. Didn't test it on GH yet but it should work.  
  I know, I should have used a branch for this, as it is irrelevant to the code.

## [0.1.1] - 2018-09-18

No functionality change.

### Added
- [CHANGELOG.md] (this file)

### Changed
- [LICENSE] file renamed from MIT-LICENSE to comply with code hosting platforms.

## 0.1.0 - 2018-09-18

### Added
- Initial release: `ActiveRecord::FixIntegerLimit` is a module to pass `limit`
  of 8 (bytes) to the constructor of `ActiveRecord::Type::UnsignedInteger`,
  applying the yet unused API of `ActiveModel::Type:Integer` to bypass the
  `DEFAULT_LIMIT` of 4 bytes than can make tests break without any good reason.  
  An alternative is to use the [activerecord-suppress_range_error] gem that
  simply does what it says, leaving the (remote) possibility of an actual (and
  undetected) overflow. Not sure my patch is better, but _it works for me_™.

[CHANGELOG.md]: ./CHANGELOG.md
[LICENSE]: ./LICENSE
[Unreleased]: /../compare/v0.1.7...HEAD
[0.1.7]: /../compare/v0.1.6...v0.1.7
[0.1.6]: /../compare/v0.1.5...v0.1.6
[0.1.5]: /../compare/v0.1.4...v0.1.5
[0.1.4]: /../compare/v0.1.3...v0.1.4
[0.1.3]: /../compare/v0.1.2...v0.1.3
[0.1.2]: /../compare/v0.1.1...v0.1.2
[0.1.1]: /../compare/v0.1.0...v0.1.1
[activerecord-suppress_range_error]: https://github.com/kamipo/activerecord-suppress_range_error
