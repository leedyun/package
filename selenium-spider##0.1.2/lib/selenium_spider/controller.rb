require "selenium_standalone_dsl"

module SeleniumSpider
  class Controller
    def self.crawl_urls(urls)
      @@urls = urls
    end

    def initialize
      @type = self.class.to_s.sub('Controller', '')
      @pagination_class = @type + 'Pagination'
    end

    def run
      @@urls.each_with_index do |url, idx|
        @pagination = SeleniumSpider.const_get(@pagination_class).new(url)
        @pagination.before_crawl idx

        while true
          if (detail_links = @pagination.detail_links)
            detail_links.each do |detail_link|
              extract_info location: detail_link
            end
          else
              extract_info driver: @pagination.driver
          end

          break if !@pagination.continue?
          @pagination.next
        end

        @pagination.quit
      end
    end

    def extract_info(location: nil, driver: nil)
      model = SeleniumSpider.const_get(@type).new(location: location, driver: driver)
      @pagination.attributes.each do |key, value|
        model.set_attributes_value(key, value.value)
      end
      puts model.output_as_json
      model.quit if location
    end
  end
end

