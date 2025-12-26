require_relative "base"

class ABBYY::Cloud
  module Namespaces
    # Namespace for operations with prices
    # @see [https://api.abbyy.cloud/swagger/ui/index#!/Prices] ABBYY Cloud API
    class Prices < Base
      MAX_PER_REQUEST = 1_000

      # Returns prices data filtered by type of translated object,
      # source and target language.
      #
      # If take option is NOT set, the method makes as many requests
      # as necessary to get all prices.
      #
      def details(skip: 0, take: nil, **opts)
        take_now   = (take && take <= MAX_PER_REQUEST) ? take : MAX_PER_REQUEST
        take_later = take - take_now if take
        skip_later = skip + take_now

        items = Operations::Prices.new(settings)
                                  .call(skip: skip, take: take_now, **opts)

        return items if (items.count < take_now) || take_later&.zero?
        items + details(skip: skip_later, take: take_later, **opts)
      end
    end
  end
end
