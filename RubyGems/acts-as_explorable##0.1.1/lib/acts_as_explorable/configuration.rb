module ActsAsExplorable
  class Configuration
    attr_accessor :filters

    def initialize
      @filters = {}
    end
  end
end
