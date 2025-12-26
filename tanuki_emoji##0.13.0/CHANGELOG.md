# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.13.0 (2024-10-25)

### Fixed (1 change)

- [Ensure no Unicode aliases collide with gemojione](https://gitlab.com/gitlab-org/ruby/gems/tanuki_emoji/-/commit/e26557d826947b78733f1c9522f73918cf86d7c1) ([merge request](https://gitlab.com/gitlab-org/ruby/gems/tanuki_emoji/-/merge_requests/75))

## 0.12.0 (2024-10-22)

### Fixed (2 changes)

- [Make the gemojione codes primary over Unicode codes](https://gitlab.com/gitlab-org/ruby/gems/tanuki_emoji/-/commit/03c59b5ea12e67290c4078c47148ddfa87a2940d) ([merge request](https://gitlab.com/gitlab-org/ruby/gems/tanuki_emoji/-/merge_requests/73))
- [Remove trailing underscaore from emoji names](https://gitlab.com/gitlab-org/ruby/gems/tanuki_emoji/-/commit/82e9574c2b58e37937baaf8c4a6099001b3cd455) ([merge request](https://gitlab.com/gitlab-org/ruby/gems/tanuki_emoji/-/merge_requests/72))

## 0.11.0 (2024-10-02)

### Added (1 change)

- [Add support for Unicdoe 15.1 emojis](https://gitlab.com/gitlab-org/ruby/gems/tanuki_emoji/-/commit/3d1f30ab5370525d7dd2ddd1667dbc481846d012) ([merge request](https://gitlab.com/gitlab-org/ruby/gems/tanuki_emoji/-/merge_requests/65))

## 0.10.0 (2024-09-30)

### Fixed (1 change)

- [Ensure that image assets are shipped with gem](https://gitlab.com/gitlab-org/ruby/gems/tanuki_emoji/-/commit/8f135d8a30e75cf4b22179f9e1f112a8a23634a9) ([merge request](https://gitlab.com/gitlab-org/ruby/gems/tanuki_emoji/-/merge_requests/67))

## 0.9.0 (2023-10-17)

### Added (1 change)

- [Added ordering information to to `Character`](gitlab-org/ruby/gems/tanuki_emoji@c618fae04409067a38ddc454d3dfaee4678da520) ([merge request](gitlab-org/ruby/gems/tanuki_emoji!61))

## 0.8.0 (2023-09-15)

### Changed (1 change)

- [Bump Ruby version to 3.1.4](gitlab-org/ruby/gems/tanuki_emoji@c7853e7b6aa5000358a8c99e402614926d479ef8) ([merge request](gitlab-org/ruby/gems/tanuki_emoji!58))

## 0.7.0 (2023-09-04)

### Added (1 change)

- [Added EmojiData and EmojiDataParser](gitlab-org/ruby/gems/tanuki_emoji@8eba857db072e099fe10eeba6c93c6a7710e01a3) ([merge request](gitlab-org/ruby/gems/tanuki_emoji!2))

## 0.6.0 (2022-02-16)

### Added

- `Character` responds to `ascii_aliases` which contain ASCII aliases from Gemojione

### Fixed

- Fixed `TanukiEmoji.add` command, which should now require `category:` to be provided
- Fixed issue where `TanukiEmoji::Index#codepoints_pattern` would split apart emoji-modifier pairs

## 0.5.0 - (2021-09-16)

### Added

- Add Category information into `Character`
- Add Character.unicode_version and index in which unicode version an emoji was introduced

## 0.4.0 - (2021-09-07)

### Added

- Index can return the `alpha_code_pattern` and `codepoints_pattern` to be used as text extraction sources

### Fixed

- Fixed `registered sign`, `copyright sign` and `trade mark sign` codepoints from gemojione index

## 0.3.0 - (2021-08-26)

### Changed

- Characters can be compared and will be considered equal when all of its attributes matches
- `:+1:` and `:-1:` which are aliases for `:thumbsup:` and `:thumbsdown:` can now be used with `find_by_alpha_code`
- added tests for both `find_by_alpha_code` and `find_by_codepoints` and make sure `find_by_alpha_code` can handle `nil` correctly

## 0.2.2 - (2021-08-23)

### Changed

- Fixed autoload load_path

## 0.2.1 - (2021-07-09)

### Changed

- Noto Emoji assets were not included due to bug in gemspec code. Now it is.

## 0.2.0 - (2021-07-09)

### Added

- Bundled Noto Emoji assets for each corresponding indexed Emoji
- `Character` responds to `#image_name` pointing to Noto Emoji filenames
- `TanukiEmoji` responds to `.images_path` pointing to Emoji assets folder

## 0.1.0 - (2021-07-04)

### Added

- Initial release with index and Character information support
