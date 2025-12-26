module Acception
  class MessageType

    def self.valid_keys
      %w(
        data
        debug
        emergency
        error
        fatal
        info
        license_violation
        warning
      )
    end

    include Enumerative::Enumeration

    # DATA
    # DEBUG
    # EMERGENCY
    # ERROR
    # FATAL
    # INFO
    # LICENSE_VIOLATION
    # WARNING

  end
end
