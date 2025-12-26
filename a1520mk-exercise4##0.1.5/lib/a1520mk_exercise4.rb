require "a1520mk_exercise4/version"
require 'date'

module A1520mkExercise4
  class A1520mkExercise4
    def self.getAge
      a = Date.new(1962, 7, 9)
      b = Date.today
      d = b - a
      return (d/365).to_i
    end
    def self.getBMI(wkg, tcm=170)
      tall = tcm/100.0
      bmi = wkg/(tall*tall)
      return bmi
    end
  end
end
