require 'movingsign_api/commands/internal/sender_receiver_address'
require 'movingsign_api/commands/internal/utilities'

module MovingsignApi
  # Command class, subclassed by each MovingsignApi class
  #
  # When subclassing, be sure to implement {#command_code} and {#command_payload_bytes}
  #
  # Also see some useful subclasses: {WriteTextCommand}, {WriteControlCommand}
  class Command
    include Utilities

    # The sender's address.  See {SenderReceiverAddress}
    attr_accessor :sender
    # The receiving sign's address.  See {SenderReceiverAddress}
    attr_accessor :receiver

    def sender=(val)
      @sender = MovingsignApi::SenderReceiverAddress.parse(val)
    end

    def receiver=(val)
      @receiver = MovingsignApi::SenderReceiverAddress.parse(val)
    end

    # Returns the command identifier string.  See specification for list of valid command codes.
    #
    # @return [String]
    def command_code
      raise MovingsignApi::NotImplementedError, "Needs to be implemented in subclass."
    end

    # Returns a byte array representing this command, appropriate for sending to the sign's serial port
    #
    # @return [Array<Byte>]
    def to_bytes
      # set defaults
      self.sender ||= :pc
      self.receiver ||= 1

      bytes = []

      bytes.concat [0x00] * 5                               # start of command
      bytes.concat [0x01]                                   # <SOH>
      bytes.concat self.sender.to_bytes                     # Sender Address
      bytes.concat self.receiver.to_bytes                   # Reciver Address
      bytes.concat [0x02]                                   # <STX>
      bytes.concat string_to_ascii_bytes(command_code)      # Command Code
      bytes.concat command_payload_bytes                    # command specific payload
      bytes.concat [0x03]                                   # <ETX>
      bytes.concat generate_checksum_bytes(bytes[10..-1])   # Checksum bytes (4)
      bytes.concat [0x04]                                   # <EOT>

      bytes
    end

    private

    # Returns command specific byte array payload
    #
    # @return [Array<Byte>]
    def command_payload_bytes
      raise MovingsignApi::NotImplementedError, "Needs to be implemented in subclass."
    end

    # Returns a checksum string (4 characters) appropriate for sending to the serial port
    #
    # ie: '12AF' (note capitalization)
    def generate_checksum_bytes(payload)
      sum = payload.reduce :+
      sum_hex = ('%04x' % sum).upcase

      string_to_ascii_bytes sum_hex
    end
  end
end
