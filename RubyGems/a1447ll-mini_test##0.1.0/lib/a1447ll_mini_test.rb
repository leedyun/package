require "a1447ll_mini_test/version"

module A1447llMiniTest
  class MyClass
    def odd? (value)
      value%2 == 1
    end

    def check_number? (value)
      (1000..9999).include? value and value%2 == 0
    end
   
    def enough_length? (string)
      (3..8).include? string.length
    end

    def divide (a, b)
      a / b
    end

    def fizz_buzz  (value)
      if value%15 == 0 
        "FizzBuzz"
      elsif value%3 == 0
        "Fizz"
      elsif value%5 == 0
        "Buzz"
      end
    end

    def hello (string)
      name = string.split.map{|word| word.capitalize}.join(' ')
      "Hello, " + name + "!"
    end   
  end
end
