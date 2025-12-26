require "a1630ty_a1630ty/version"

def age(a,b,c)
  
  require 'date'
  birthday = Date.new(a,b,c)
  today = Date.today # 2014/3/27

  age = today.year - birthday.year
  if today.month < birthday.month or (today.month == birthday.month and today.day < birthday.day)
    age -= 1 # まだ誕生日を迎えていない
  end
  puts age
  #puts 'Hello World'
  #puts A1630tyA1630ty::VERSION
end
