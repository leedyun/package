require 'movingsign_api/commands/internal/pretty_keyable'
require 'movingsign_api/commands/internal/utilities'

module MovingsignApi
  # Text display pause setting (in seconds, 0 - 9)
  class DisplayPause
    include Utilities

    # @return [Integer] seconds
    attr_accessor :seconds

    # @param seconds [Integer] Time to pause (in seconds) (0 - 9)
    def initialize(seconds)
      @seconds = parse_seconds(seconds)
    end

    def to_bytes
      string_to_ascii_bytes self.seconds
    end

    private

    def parse_seconds(input)
      if input.kind_of?(String) && input.match(/\A[0-9]\z/)
        input.to_i
      elsif input.kind_of?(Fixnum) && input.between?(0, 9)
        input
      else
        raise "Pause time '#{input}' is invalid."
      end
    end
  end
end