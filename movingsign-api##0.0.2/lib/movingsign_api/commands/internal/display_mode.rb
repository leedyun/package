require 'movingsign_api/commands/internal/pretty_keyable'

module MovingsignApi
  # Text display mode setting.
  class DisplayMode
    include PrettyKeyable

    # @!visibility private
    def self.display_mode(key, code)
      register key, code
    end

    # @!group Display Mode Constants
    # @!macro [attach] dm.display_mode
    #   @!attribute [r] $1
    #   Display mode $1 (protocol display mode +'$2'+)
    #   @return [Symbol] +:$1+
    display_mode :auto, 'A'
    display_mode :flash, 'B'
    display_mode :hold, 'C'
    display_mode :interlock, 'D'
    display_mode :rolldown, 'E'
    display_mode :rollup, 'F'
    display_mode :rollin, 'G'
    display_mode :rollout, 'H'
    display_mode :rollleft, 'I'
    display_mode :rollright, 'J'
    display_mode :rotate, 'K'
    display_mode :slide, 'L'
    display_mode :snow, 'M'
    display_mode :sparkle, 'N'
    display_mode :spray, 'O'
    display_mode :starburst, 'P'
    display_mode :switch, 'Q'
    display_mode :twinkle, 'R'
    display_mode :wipedown, 'S'
    display_mode :wipeup, 'T'
    display_mode :wipein, 'U'
    display_mode :wipeout, 'V'
    display_mode :wipeleft, 'W'
    display_mode :wiperight, 'X'
    display_mode :cyclecolor, 'Y'
    display_mode :clock, 'Z'
    # @!endgroup

    # @return [Symbol] display mode constant (see attributes {#auto}, {#flash}, {#hold}, etc.)
    attr_accessor :key

    def initialize(mode)
      @key = mode
    end

    def self.parse(input)
      if key = parse_to_key(input)
        self.new key
      else
        raise InvalidInputError, "Display mode '#{input}' is not valid."
      end
    end
  end
end