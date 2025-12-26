# frozen_string_literal: true

module Gitlab
  module Triage
    module Action
      class Base
        attr_reader :policy, :network

        def initialize(**args)
          @policy = args[:policy]
          @network = args[:network]
        end
      end
    end
  end
end
