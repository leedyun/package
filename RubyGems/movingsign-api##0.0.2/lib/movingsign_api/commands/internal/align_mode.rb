require 'movingsign_api/commands/internal/pretty_keyable'

module MovingsignApi
  # Align mode for a sign.
  #
  # Valid values are:
  # * +:left+ or +'1'+
  # * +:center+ or +'2'+
  # * +:right+ or +'3+
  class AlignMode
    include PrettyKeyable

    # @return [Symbol] align mode (one of {#left}, {#right}, {#center})
    attr_accessor :key

    protected

    # Registers a specific align mode key and value combo
    def self.align_mode(key, code)
      register key, code
    end

    public

    # @!group Align Mode Constants
    # @!macro [attach] dm.align_mode
    #   @!attribute [r] $1
    #   Align mode +:$1+ (protocol align mode +'$2'+)
    #   @return [Symbol] +:$1+
    align_mode :left, '1'
    align_mode :right, '3'
    align_mode :center, '2'
    # @!endgroup

    # @param key [Symbol] one of the valid alignment keys
    def initialize(key)
      @key = key
    end

    # Parses an symbol or string into a valid {AlignMode} instance
    # @return [AlignMode]
    def self.parse(input)
      if key = parse_to_key(input)
        self.new key
      else
        raise InvalidInputError, "Align mode '#{input}' is invalid."
      end
    end
  end
end
