require 'movingsign_api/commands/internal/pretty_keyable'

module MovingsignApi
  # Text display mode speed sending
  class DisplaySpeed
    include PrettyKeyable

    # @!visibility private
    def self.display_speed(key, code)
      register(key, code)
    end

    # @!group Display speed constants

    # @!macro [attach] dm.display_speed
    #   @!attribute [r] $1
    #   Display speed +:$1+ (protocol display speed +'$2'+)
    #   @return [Symbol] +:$1+
    display_speed :fastest, '1'
    display_speed :faster, '2'
    display_speed :normal, '3'
    display_speed :slow, '4'
    display_speed :slower, '5'

    # @!endgroup

    # @return [Symbol] Display speed constant, one of {#faster}, {#normal}, {#slow}
    attr_accessor :key

    def initialize(speed)
      @key = speed
    end

    # Parses the supplied input into a {DisplaySpeed} instance if possible
    # @raise InvalidInputError on invalid input
    # @return [DisplaySpeed]
    def self.parse(input)
      if key = parse_to_key(input)
        self.new key
      else
        raise InvalidInputError, "Display speed '#{input}' is invalid."
      end
    end
  end
end