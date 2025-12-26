module MovingsignApi
  module Utilities
  # @!visibility private
  def string_to_ascii_bytes(input)
      input.to_s.unpack('C*')
    end
  end
end