require "royal_mail_scraper/version"
require "royal_mail_scraper/tracker"
require "royal_mail_scraper/tracker/errors"
require "royal_mail_scraper/tracker/request"
require "royal_mail_scraper/tracker/response"
require "royal_mail_scraper/tracker/detail"
require "royal_mail_scraper/tracker/status_map"

module RoyalMailScraper
  TRACKING_NUMBER_FORMAT = /\A[A-Z]{2}\d{9}GB\z/i

  class << self
    def tracking_number?(tracking_number)
      !!(tracking_number.to_s =~ TRACKING_NUMBER_FORMAT)
    end
  end
end
