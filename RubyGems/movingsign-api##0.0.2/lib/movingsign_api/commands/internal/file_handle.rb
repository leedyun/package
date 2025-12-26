require 'movingsign_api/commands/internal/utilities'

module MovingsignApi
  # Text file handle
  #
  # Valid values are:
  # * Integer - (0 - 35)
  # * String '0' - '9', 'A' - 'Z'
  class FileHandle
    include Utilities

    # @return [Integer] the file hander integer
    attr_accessor :handle

    def initialize(input)
      self.handle = self.class.parse_file_handle(input)
    end

    # Returns the file handle as an integer when given a file handle string
    def self.code_to_handle(code)
      if code.match /[0-9]/
        code.to_i
      else
        (code.unpack('C')[0] - 'A'.unpack('C')[0]) + 10
      end
    end

    # Returns a file handle string when given a file handle integer
    def self.handle_to_code(handle)
      if handle.between?(0,9)
        handle.to_s
      else
        (0x41 + handle - 10).chr
      end
    end

    def to_bytes
      string_to_ascii_bytes self.class.handle_to_code(self.handle)
    end

    private

    def self.parse_file_handle(input)
      if input.kind_of?(Fixnum) && input.between?(0, 35)
        input
      elsif input.kind_of?(String) && input.match(/\A[0-9A-Z]\z/)
        code_to_handle(input)
      else
        raise InvalidInputError, "File handle '#{input}' is invalid."
      end
    end

  end
end