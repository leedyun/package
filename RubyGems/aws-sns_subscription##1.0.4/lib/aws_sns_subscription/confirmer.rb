require "active_support/concern"
require "httparty"

module AWSSNSSubscription
  module Confirmer
    extend ActiveSupport::Concern
    class MessageWasNotAuthentic < StandardError; end

    def respond_to_aws_sns_subscription_confirmations
      if request.headers["x-amz-sns-message-type"] == "SubscriptionConfirmation"
        sns = SNS.new(request.raw_post)
        raise MessageWasNotAuthentic unless sns.authentic?
        HTTParty.get sns.subscribe_url
        head :ok and return
      end
    end
  end
end
