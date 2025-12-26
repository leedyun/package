require "a15745105_ichinoki/version"


class Object
  def bmi_cal_ichinoki(kg, cm)
    if kg <= 0 || cm <= 0
      puts "Please input your weight and height"
    else
      bim = kg.to_f / (cm.to_f * 0.01) ** 2
      puts "Your BMI is #{bim.round(1)}"
    end
  rescue ArgumentError => ex
      puts "Not input Sitrng!!"
  end
end
