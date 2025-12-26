require "selenium_standalone_dsl"

module SeleniumSpider
  class Pagination < SeleniumStandaloneDSL::Base
    @@attributes = {}

    def attributes
      @@attributes
    end

    def self.next_link(selector, find_by: :link_text)
      @@next_link = selector
      @@next_link_find_by = find_by
    end

    def self.no_next_link
      @@next_link = nil
    end

    def self.detail_links(selector)
      @@detail_links_selector = selector
    end

    def self.no_detail_link
      @@detail_links_selector = nil
    end

    def initialize(start_url)
      super()
      visit start_url
      @uri = URI.parse(start_url)
    end

    # You can define something to do before crawling
    def before_crawl(times)
    end

    def next
      click @@next_link, find_by: @@next_link_find_by
    end

    def detail_links
      return false if !@@detail_links_selector
      search(@@detail_links_selector).map(&->(x) { full_url(x.attribute('href').value) } )
    end

    def full_url(path)
      port = (@uri.port == 80) ? '' : ':' + @uri.port.to_s
      @uri.scheme + '://' + @uri.host + port + path
    end

    def continue?
      return false if !@@next_link
      has_element?(@@next_link, find_by: @@next_link_find_by)
    end

    def register(attr_name_sym)
      @@attributes[attr_name_sym] = SeleniumSpider::Attribute.new
      yield @@attributes[attr_name_sym] if block_given?
    end
  end
end
