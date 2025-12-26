class YahooController < SeleniumSpider::Controller
  crawl_urls ['http://localhost:4567/list/1', 'http://localhost:4567/list/2']
end

