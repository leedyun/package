require 'movingsign_api/commands/write_control_command'

module MovingsignApi
  # Performs a soft reset of the sign
  #
  # @note The sign will restart after receiving this command.
  class SoftwareResetCommand < WriteControlCommand
    def subcommand_code
      'B'
    end

    def subcommand_payload_bytes
      []
    end
  end
end