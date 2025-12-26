require "a15z8my_name/version"

module A15z8myName
  class A15z8myName
    def calcBmi(h, w)
      begin
        if h.class() == Float
          exit(1)
        end
      rescue SystemExit
        $stderr.puts "input your height as cm"
        return false
      end

      w_h = h.to_f / 100
      
      bmi = w / (w_h**2)
      best_weight = (w_h**2) * 22

      $stdout.print "Your BMI : ", bmi.round(2), "\n"
      $stdout.print "Your Best Weight : ", best_weight.round(2), "\n"
    end
  end
end
