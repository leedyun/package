module MovingsignApi
  # Base error for all MovingsignApi errors.
  class Error < StandardError

  end

  # Raised when a method has been be implemented, usually due to improperly subclassed class or code that is in
  # progress.
  class NotImplementedError < Error

  end

  # Raised when an input is invalid in the given context.
  class InvalidInputError < Error

  end

  # Raised when there are errors reading/writing to the serial port
  class IOError < Error

  end
end