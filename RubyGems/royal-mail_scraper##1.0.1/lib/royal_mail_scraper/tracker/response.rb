require 'nokogiri'

module RoyalMailScraper
  class Tracker::Response
    attr_reader :html

    DETAILS_PATH = '//*[@id="bt-tracked-track-trace-form"]/div/div/div/div[1]/table/tbody/tr'
    ERROR_PATH = '//*[@id="bt-tracked-track-trace-form"]/div/div/div/div[1]/div[5]/text()'

    TIME_FORMAT = '%d/%m/%y %H:%M'

    def initialize(body)
      @html = Nokogiri::HTML(body)
    end

    def tracker
      Tracker.new(tracking_number, details.reverse)
    end

    private

    def tracking_number
      el = @html.at('input[@name="tracking_number"]')
      el ? el.attr(:value).to_s.strip : nil
    end

    def details
      html.xpath(DETAILS_PATH).map do |tr|
        date, time, message, location = tr.css('td').map(&:content).map(&:strip)
        time = '00:00' unless time =~ /\A\d+:\d+\z/
        datetime = DateTime.strptime([date, time].join(' '), TIME_FORMAT) rescue DateTime.new
        Tracker::Detail.new(datetime, message, location)
      end
    end
  end
end
