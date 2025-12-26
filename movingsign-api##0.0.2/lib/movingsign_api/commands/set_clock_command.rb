require 'movingsign_api/commands/write_control_command'

module MovingsignApi
  # Sets the signs date + time
  class SetClockCommand < WriteControlCommand
    # @return [Time]
    attr_accessor :datetime

    def subcommand_code
      'A'
    end

    private

    def subcommand_payload_bytes
      bytes = []

      # date
      bytes.concat string_to_ascii_bytes(self.datetime.year)
      bytes.concat string_to_ascii_bytes('%02d' % self.datetime.month)
      bytes.concat string_to_ascii_bytes('%02d' % self.datetime.day)
      # time
      bytes.concat string_to_ascii_bytes('%02d' % self.datetime.hour)
      bytes.concat string_to_ascii_bytes('%02d' % self.datetime.min)
      bytes.concat string_to_ascii_bytes('%02d' % self.datetime.sec)
      # day of week
      bytes.concat string_to_ascii_bytes(self.datetime.wday)

      bytes
    end
  end
end