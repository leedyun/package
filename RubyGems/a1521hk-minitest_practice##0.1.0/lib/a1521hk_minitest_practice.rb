require "a1521hk_minitest_practice/version"

module A1521hkMinitestPractice
  class Main
    def odd?(n)
      if n % 2 == 1 
        return true
      else
        return false
      end
    end

    def check_number?(n)
      if n.to_s.length == 4 and n % 2 == 0
        return true
      else
        return false
      end
    end

    def enough_length?(s)
      if s.length >= 3 and s.length <= 8
        return true
      else
        return false
      end
    end

    def devide(x,y)
      return x / y
    end

    def fizz_buzz(n)
      str = ""
      if n % 3 == 0
        str = "Fizz" 
      end
      if n % 5 == 0
        str = str + "Buzz" 
      end
      return str
    end

    def hello
      p "Hello"
    end

  end
end

