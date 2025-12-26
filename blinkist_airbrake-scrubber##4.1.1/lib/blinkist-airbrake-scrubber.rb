require 'airbrake'
Dir[File.expand_path('../../lib/**/*.rb', __FILE__)].each do |f|
  require f
end

# Prepend the original Airbrake module
# Note: Do not remove from this file, it needs to be before Blinkist::AirbrakeScrubber
module Airbrake
  class << self
    prepend Blinkist::AirbrakeScrubber
  end
end

# Set up the namespace and run every scrubber listed in SCRUBBERS
module Blinkist
  module AirbrakeScrubber
    FILTERED  = '[Filtered]'
    SCRUBBERS = [ MessageEmail, ParamsEmail, ParamsPassword, ParamsTokens ]

    # Override original Airbrake.configure
    def configure(*args, &block)
      super(&block)
    ensure
      Blinkist::AirbrakeScrubber.run!
    end

    # Run scrubbers
    def self.run!
      SCRUBBERS.each { |scrubber| scrubber::scrub! }
    end

  end
end
