require "a1436mm_age/version"
require "date"
module A1436mmAge
    def self.birth(age) 
    d = Date.today.year - age.to_i 
    return d
    end
end
