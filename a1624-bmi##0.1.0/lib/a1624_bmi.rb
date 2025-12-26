require "a1624_bmi/version"

    def compute(mass, height)
      bmi = mass / (height * height)
      p sprintf("BMI = %.1f", bmi)
      if bmi < 18.5 then
        print("thin")
      elsif bmi < 25.0 then
        print("normal")
      elsif bmi < 30.0 then
        print("fat level one")
      elsif bmi < 35.0 then
        print("fat level two")
      elsif bmi < 40.0 then
        print("fat level three")
      else
        print("fat level four")
      end
    end
