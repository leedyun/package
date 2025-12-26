require "a1510jy_bmi/version"

module A1510jyBmi
  class BMI
    def self.compute(mass, height)
      sprintf("BMI = %.1f", mass / (height * height))
    end
  end
end
