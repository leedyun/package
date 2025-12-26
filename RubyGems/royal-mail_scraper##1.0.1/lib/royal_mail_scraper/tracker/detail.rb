module RoyalMailScraper
  class Tracker::Detail
    attr_reader :datetime, :message, :location, :status

    def initialize(datetime, message, location)
      @datetime = datetime
      @message = message
      @location = location
      @status = Tracker::StatusMap.resolve(message)
    end
  end
end
