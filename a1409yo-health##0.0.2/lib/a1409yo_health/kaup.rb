module A1409yoHealth
  module Kaup
    def self.exec(weight, height)
      (weight.to_f/height.to_f**2) * 10000.0
    end
  end
end
