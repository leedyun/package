module RoyalMailScraper
  class Tracker::StatusMap
    UNRECOGNISED = 'unrecognised'
    IN_TRANSIT = 'in_transit'
    ON_DELIVERY = 'on_delivery'
    UNDELIVERED = 'undelivered'
    HELD_AT_ENQUIRY_OFFICE = 'held_at_enquiry_office'
    DELIVERED = 'delivered'

    def self.resolve(message)
      case message
      when /^(ACCEPTED|RECEIVED|DESPATCHABLE|DESPATCHED|COLLECTED|ARRIVED)/
        IN_TRANSIT
      when /^ON DELIVERY/
        ON_DELIVERY
      when /^UNDELIVERED/
        UNDELIVERED
      when /^HELD AT ENQUIRY/
        HELD_AT_ENQUIRY_OFFICE
      when /^DELIVERED/
        DELIVERED
      else
        UNRECOGNISED
      end
    end
  end
end
