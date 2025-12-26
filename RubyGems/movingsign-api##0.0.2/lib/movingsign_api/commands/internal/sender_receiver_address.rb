require 'movingsign_api/commands/internal/utilities'

module MovingsignApi
  # Represents a sender or receiver identifier for a {Command}
  #
  # A address can be represented as an integer between 0 and 255, or per the spec as a two character hex string: '00' - 'FF'.
  #
  # Valid inputs include:
  # - Integer - +0+ - +255+
  # - Symbol - +:broadcast+ or +:pc+
  # - String - +'00'+ - +'FF'+
  #
  # Some notes:
  #
  # - Broadcast Address: (+:broadcast+, +0+, or +'00'+) is a broadcast identifier and shouldn't be used as a sender
  # - PC Address: (+:pc+, +255+, or +'FF''+) is reserved to represent the "PC address" and shouldn't be used as a recipient
  #
  class SenderReceiverAddress
    include Utilities

    # @return [Integer] the address repsented as an integer
    attr_accessor :identifier

    # @param identifier [String] Identifier hex string, or hex string with wildcard
    def initialize(identifier)
      @identifier = identifier
    end

    # Parses the specified input value returning an appropriate {SenderReceiver} instance or raises.
    #
    # @raise [InvalidInputError] on invalid input
    # @return [SenderReceiverAddress]
    def self.parse(input)
      raise MovingsignApi::InvalidInputError, "nil not allowed" if input.nil?

      value = nil
      if input.kind_of? Fixnum
        if input.between?(0, 255)
          value = ('%02x' % input).upcase
        else
          raise MovingsignApi::InvalidInputError, "Integer #{input} is out of the valid range."
        end
      elsif input.kind_of? Symbol
        if input == :broadcast
          value = '00'
        elsif input == :pc
          value = 'FF'
        else
          raise MovingsignApi::InvalidInputError, "Symbol :#{input} isn't supported"
        end
      elsif input.kind_of? String
        if (value = input.upcase.match /\A[0-9,A-F\?]{2}\z/)
          value = value[0]
        else
          raise MovingsignApi::InvalidInputError, "Parsing string '#{input}' isn't supported"
        end
      else
        raise MovingsignApi::InvalidInputError, "Parsing '#{input.class}' isn't supported"
      end

      self.new(value)
    end

    # Returns true if this represents the special 'broadcast' address
    def broadcast?
      self.identifier == '00'
    end

    # Returns true if this represents the special 'pc' address
    def pc?
      self.identifier = 'FF'
    end

    def to_s
      self.identifier
    end

    def to_bytes
      string_to_ascii_bytes self.identifier
    end
  end
end
