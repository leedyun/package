require "a1439ty_bmiV3/version"

module A1439tyBmiV3
  # Your code goes here...
  
  print("height(cm):")
  height = gets.to_f
  print("body weight(kg):")
  weight = gets.to_f
  bmi = ( weight / ( height/100)**2)
  puts("BMI  ",bmi)
  
end
