# MovieSpider

单车网电影信息爬虫

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'movie_spider'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install movie_spider

## Usage
###从时光网获取影片信息、剧照、海报
`MovieSpider.fetch_info_from_mtime("超能陆战队", "2014")`
`MovieSpider.fetch_stills_from_mtime("超能陆战队", "2014")`
`MovieSpider.fetch_posters_from_mtime("超能陆战队", "2014")`
###从豆瓣网获取影片信息、剧照、海报
`MovieSpider.fetch_info_from_douban("超能陆战队", "2014")`
`MovieSpider.fetch_stills_from_douban("超能陆战队", "2014")`
`MovieSpider.fetch_posters_from_douban("超能陆战队", "2014")`
###通过豆瓣ID或时光网id获取以上信息，只使用id参数调用，不需要传影片年份，注意ID要对应好，使用豆瓣的ID获取豆瓣电影信息，使用时光网ID获取时光网电影信息。
`MovieSpider.fetch_(info|posters|stills)_from_douban("11026735")`	
`MovieSpider.fetch_(info|posters|stills)_from_mtime("160162")`
以上都是获取电影木星上行的信息。


## Contributing

1. Fork it ( https://github.com/[my-github-username]/movie_spider/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
