require "a1412tk_bmi/version"

module A1412tkBmi

  def self.calc(height_cm, weight_kg)
    height_m = height_cm / 100
    bmi = weight_kg / (height_m * height_m)
    bmi.round(1)
  end

end
