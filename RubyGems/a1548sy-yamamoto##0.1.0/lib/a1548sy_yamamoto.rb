require "a1548sy_yamamoto/version"

module A1548syYamamoto
   def hello(name)
      print "Hello, " , name, ".\n"
   end
   module_function :hello

   def bmi(height,weight)
      bmi = weight / (height/100.0) ** 2
      print("Your BMI is ", bmi, ".\n") 
   end
   module_function :bmi

end
