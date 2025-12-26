require "a1420ks_bmi/version"

module A1420ksBmi
    def self.getbmi
        print "Enter your Height ==>"
        height = gets.to_i
        print "\n"
        print "Enter your Weight ==>"
        weight = gets.to_i
        height = height ** 2
        bmi = weight / height.to_f
        bmi = bmi * 100
        print "\n"
        printf("Your BMI index is %.3f",bmi.to_f)
    end
end
