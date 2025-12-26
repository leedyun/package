require 'movingsign_api/commands/write_control_command'

module MovingsignApi
  # Performs a hard reset, <b>DELETING ALL DATA ON THE SIGN</b>
  #
  # @note The sign will restart after receiving this command
  class HardResetCommand < WriteControlCommand
    def subcommand_code
      'L'
    end

    def subcommand_payload_bytes
      []
    end
  end
end