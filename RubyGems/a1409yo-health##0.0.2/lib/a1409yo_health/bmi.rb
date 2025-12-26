module A1409yoHealth
  module BMI
    def self.exec(weight, height)
      weight.to_f / ((height.to_f/100.0) ** 2)
    end
  end
end
