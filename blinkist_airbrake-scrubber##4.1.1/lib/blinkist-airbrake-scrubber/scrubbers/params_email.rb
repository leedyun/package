module Blinkist
  module AirbrakeScrubber
    class ParamsEmail

      def self.scrub!
        ::Airbrake.add_filter do |notice|
          notice[:params] = DeepTraversal.new(notice[:params]).traverse do |key, value|
            value = FILTERED if key.to_s == 'email'
            value
          end
          notice
        end
      end # def self.scrub!

    end
  end
end
