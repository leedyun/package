# Extends AR to add a configurable read-only mode.
module ActiveRecord
  class Base
    def readonly?
            (ENV['DB_READ_ONLY'] == "true") || false
    end
  end
end
