# coding: utf-8
require "a15666011_konagayoshi/version"

module A15666011Konagayoshi
  # Your code goes here...
  class Test
    def self.hi
      puts "Hello world!"
    end
    def self.bmi
      puts'Calculation of BMI'
      print'Input your Height(centi meter)：'
      input_height = gets.chomp
      print'Input your Weight(kg)：'
      input_weight = gets.chomp
      bmi = (input_weight.to_f / ((input_height.to_f / 100) ** 2)).round(3)
    end    
  end
end
