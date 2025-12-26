# admiral_stats_parser

[![Build Status](https://travis-ci.org/muziyoshiz/admiral_stats_parser.svg?branch=master)](https://travis-ci.org/muziyoshiz/admiral_stats_parser) [![Join the chat at https://gitter.im/muziyoshiz/admiral_stats](https://badges.gitter.im/muziyoshiz/admiral_stats.svg)](https://gitter.im/muziyoshiz/admiral_stats?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Parser for admiral stats JSON data exported from kancolle-arcade.net

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'admiral_stats_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install admiral_stats_parser

## Usage

```
# 基本情報
AdmiralStatsParser.parse_personal_basic_info(json, api_version)

# 海域情報
AdmiralStatsParser.parse_area_capture_info(json, api_version)

# 艦娘図鑑
AdmiralStatsParser.parse_tc_book_info(json, api_version)

# 装備図鑑
AdmiralStatsParser.parse_equip_book_info(json, api_version)

# 艦娘一覧
AdmiralStatsParser.parse_character_list_info(json, api_version)

# 装備一覧
AdmiralStatsParser.parse_equip_list_info(json, api_version)

# イベント海域情報
AdmiralStatsParser.parse_event_info(json, api_version)

# 改装設計図一覧
AdmiralStatsParser.parse_blueprint_list_info(json, api_version)

# 輸送イベント海域情報
AdmiralStatsParser.parse_cop_info(json, api_version)
```

## Specification

提督情報ページから返される JSON メッセージの形式は、過去に何度か変更されており、今後も変更される可能性があります。このツールでは、kancolle-arcade.net が返す JSON メッセージの形式のことを API version と呼びます。

AdmiralStatsParser は、以下の API version をサポートしています。

| API version | 期間 |
|------------:|:-----|
| 1           | 2016-04-26 〜 2016-06-29 |
| 2           | 2016-06-30（REVISION 2 のリリース日）〜 2016-09-14 |
| 3           | 2016-09-15 〜 2016-10-26 |
| 4           | 2016-10-27 〜 2016-12-20 |
| 5           | 2016-12-21 〜 2017-02-13 |
| 6           | 2017-02-14 〜 2017-04-25 |
| 7           | 2017-04-26 〜 2017-05-31（第2回イベントの終了日） |
| 8           | 2017-06-01 〜 2017-07-30 |
| 9           | 2017-07-31 〜 2017-09-20 |
| 10          | 2017-09-21 〜 2018-01-31 |
| 11          | 2018-02-01 （VERSION A REVISION 3 のリリース日） 〜 2018-02-15 |
| 12          | 2018-02-16 （ケッコンカッコカリの実装日） 〜 2018-04-18 |
| 13          | 2018-04-19 （第4回イベントの EO 開始日） 〜 2018-05-13 |
| 14          | 2018-05-14 （大型艦建造の実装日） 〜 2018-07-23 |
| 15          | 2018-07-24 （VERSION B のリリース日） 〜 2019-05-08 |
| 16          | 2019-05-09 （三周年記念キャンペーンの開始日） 〜 2019-07-03 |
| 17          | 2019-07-04 （VERSION B REVISION 6 のリリース日 〜 |

各 API version でパースできる JSON の種類は以下の通りです。また、同じ情報でも、API version によって、含まれる情報量が異なる場合があります。その場合は Supported (1), Supported (2) のように記載して区別しています。

| API version | 基本情報 | 海域情報 | 艦娘図鑑 | 装備図鑑 |
|------------:|:-----|:-----|:-----|:-----|
| 1           | Supported (1) | Supported (1) | Supported (1) | Supported |
| 2 〜 6      | Supported (2) | Supported (2) | Supported (2) | Supported |
| 7 〜 10     | Supported (3) | Supported (3) | Supported (2) | Supported |
| 11         | Supported (3) | Supported (4) | Supported (2) | Supported |
| 12 〜 13    | Supported (3) | Supported (4) | Supported (3) | Supported |
| 14 〜 15    | Supported (3) | Supported (4) | Supported (4) | Supported |
| 17          | Supported (3) | Supported (4) | Supported (5) | Supported |

| API version | 艦娘一覧 | 装備一覧 | イベント海域情報 |
|------------:|:-----|:-----|:-----|
| 1           | Unsupported   | Unsupported   | Unsupported   |
| 2           | Supported (1) | Supported (1)| Unsupported   |
| 3           | Supported (2) | Supported (1) | Unsupported   |
| 4           | Supported (2) | Supported (1) | Supported (1) |
| 5 〜 6      | Supported (3) | Supported (1) | Supported (1) |
| 7 〜 8      | Supported (4) | Supported (1) | Supported (2) |
| 9 〜 11     | Supported (4) | Supported (2) | Supported (2) |
| 12          | Supported (5) | Supported (2) | Supported (2) |
| 13          | Supported (5) | Supported (2) | Supported (3) |
| 14 〜 17     | Supported (6) | Supported (2) | Supported (3) |

| API version | 改装設計図一覧 | 輸送イベント海域情報 |
|------------:|:-----|:-----|
| 1 〜 6   | Unsupported | Unsupported |
| 7        | Supported (1) | Unsupported |
| 8 〜 14  | Supported (2) | Unsupported |
| 15 〜 17 | Supported (2) | Supported (1) |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Test

```
$ bundle exec rake spec
```

## Release

```
$ vi lib/admiral_stats_parser/version.rb
$ bundle exec rake build
$ bundle exec rake release
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/muziyoshiz/admiral_stats_parser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

