require 'movingsign_api/commands/command'

module MovingsignApi
  # Write control command base class, subclassed by actual implementations
  #
  # In subclasses, be sure to implement:
  # - {#subcommand_code}
  # - {#subcommand_payload_bytes}
  class WriteControlCommand < Command
    def command_code
      'W'
    end

    def subcommand_code
      raise MovingsignApi::NotImplementedError, "Needs to be implemented in subclass."
    end

    private

    def command_payload_bytes
      bytes = []

      bytes.concat string_to_ascii_bytes subcommand_code
      bytes.concat subcommand_payload_bytes

      bytes
    end

    # generates control sub-command specific bytes
    def subcommand_payload_bytes
      raise MovingsignApi::NotImplementedError, "Needs to be implemented in subclass."
    end

  end
end