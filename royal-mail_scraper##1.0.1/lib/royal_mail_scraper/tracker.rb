module RoyalMailScraper
  class Tracker < Struct.new(:tracking_number, :details)
    def self.fetch(tracking_number)
      request = Request.new(tracking_number)
      response = request.execute
      response.tracker
    end

    def datetime
      last_detail.datetime if last_detail
    end

    def status
      last_detail.status if last_detail
    end

    def message
      last_detail.message if last_detail
    end

    def location
      last_detail.location if last_detail
    end

    def recognised_details
      details.select { |detail| detail.status != StatusMap::UNRECOGNISED }
    end

    private

    def last_detail
      @last_detail ||= details.last
    end
  end
end
