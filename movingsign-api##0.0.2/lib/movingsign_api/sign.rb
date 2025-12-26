require 'serialport'

module MovingsignApi
  # Manipulates a Movingsign attached to a serial port
  #
  # @example Construct a sign
  #   require 'movingsign_api'
  #
  #   sign = MovingsignApi::Sign.new('/dev/ttyUSB0')
  #
  # @example Show Text
  #   sign.show_text('Hello World!')
  #
  # @example Turn Sound Off
  #   sign.set_sound false
  #
  class Sign
    # Serial port device path (ie: /dev/ttyUSB0)
    attr_accessor :device_path

    # @param device_path [String] the serial port device path (ie: /dev/ttyUSB0, different depending on platform)
    def initialize(device_path)
      @device_path = device_path
    end

    # Show the {#device_path} value on the display (useful for diagnostics)
    def show_identity
      cmd = WriteTextCommand.new
      cmd.text = self.device_path

      send_command cmd
    end

    # Displays the given text on the board.
    #
    # This is short-hand for the {WriteTextCommand}
    #
    # @param text [String] the text to display on the sign
    # @param options [Hash] options for {WriteTextCommand}
    # @option options [Integer] :display_pause (2) Time to pause (in seconds) between pages of text.  See {WriteTextCommand#display_pause}
    #
    # @return [self]
    def show_text(text, options = {})
      cmd = WriteTextCommand.new
      cmd.display_pause = options[:display_pause] if options[:display_pause]
      cmd.text = text

      send_command cmd
    end
    alias :write_text :show_text

    # Turns on/off sound when the sign receives a command
    #
    # This is a shorthand for {SetSoundCommand}
    #
    # @param on [Boolean] true to turn sound on, false otherwise
    #
    # @return [self]
    def set_sound(on)
      cmd = SetSoundCommand.new on

      send_command cmd
    end

    # Sends the specified Movingsign command to this sign's serial port
    #
    # @param [MovingsignApi::Command] command subclass to send
    #
    # @return [self]
    def send_command(command)
      SerialPort.open(self.device_path, 9600, 8, 1) do |port|
        # flush anything existing on the port
        port.flush
        flush_read_buffer(port)

        byte_string = command.to_bytes.pack('C*')

        begin
          while byte_string && byte_string.length != 0
            count = port.write_nonblock(byte_string)
            byte_string = byte_string[count,-1]

            port.flush
          end
        rescue IO::WaitWritable
          if IO.select([], [port], [], 5)
            retry
          else
            raise IOError, "Timeout writing command to #{self.device_path}"
          end
        end

        # wait for expected confirmation signals
        got_eot = false
        got_soh = false
        loop do
          begin
            c = port.read_nonblock(1)

            case c
              when "\x04"
                if ! got_eot
                  got_eot = true
                else
                  raise IOError, "Got EOT reply twice from #{self.device_path}"
                end
              when "\x01"
                if got_eot
                  if ! got_soh
                    got_soh = true

                    break
                  else
                    raise IOError, "Got SOH twice from #{self.device_path}"
                  end
                else
                  raise IOError, "Got SOH before EOT from #{self.device_path}"
                end
            end
          rescue IO::WaitReadable
            if IO.select([port], [], [], 3)
              retry
            else
              raise IOError, "Timeout waiting for command reply from #{self.device_path}.  EOT:#{got_eot} SOH:#{got_soh}"
            end
          end
        end
      end

      self
    end

    private

    def flush_read_buffer(port)
      begin
        while true
          port.read_nonblock(1024)
        end
      rescue IO::WaitReadable
      end
    end
  end
end