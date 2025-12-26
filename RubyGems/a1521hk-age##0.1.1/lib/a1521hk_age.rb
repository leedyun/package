require "a1521hk_age/version"
require "date"

class Age
  def self.cal(year,month,day)
    birthday = Date.new(year, month, day)
    today = Date.today

    age = today.year - birthday.year
    if today.month < birthday.month or (today.month == birthday.month and today.day < birthday.day)
      age -= 1
    end
    p age
  end
end

