module A1409yoHealth
  module Rohrer
    def self.exec(weight, height)
      (weight.to_f/height.to_f**3) * 10000000.0
    end
  end
end
