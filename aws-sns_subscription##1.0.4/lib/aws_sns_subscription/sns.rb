module AWSSNSSubscription
  class SNS

    attr_reader :raw

    def initialize(json)
      @raw = json
    end

    def subscribe_url
      JSON.parse(raw)["SubscribeURL"]
    end

    def authentic?
      subscribe_url =~ /^https.*amazonaws\.com\//
    end

  end
end