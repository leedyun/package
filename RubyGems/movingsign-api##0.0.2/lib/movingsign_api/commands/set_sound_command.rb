require 'movingsign_api/commands/write_control_command'

module MovingsignApi
  # Sets the sound on/off property of the sign
  class SetSoundCommand < WriteControlCommand
    attr_accessor :on

    # @param sound_on [Boolean] +true+ to turn sound on, +false+ otherwise
    def initialize(sound_on)
      @on = sound_on
    end

    def subcommand_code
      'J'
    end

    def subcommand_payload_bytes
      string_to_ascii_bytes(@on ? '1' : '0')
    end
  end
end