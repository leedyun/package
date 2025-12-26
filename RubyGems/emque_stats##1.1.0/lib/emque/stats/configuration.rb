module Emque
  module Stats
    class Configuration
      attr_accessor :emque_producing_configuration

      def initialize
        @emque_producing_configuration = nil
      end
    end
  end
end
