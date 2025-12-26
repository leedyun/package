require "wordify_stuckiest/version"
require "wordify_stuckiest/greeting"

module WordifyStuckiest
  
  def self.reversify(str)
    str.split("").reverse.join('')
  end

  def self.casify(str)
    to_case = [:upcase, :downcase]
    arr = str.split("")
    arr.each_with_index do |letter, i|
      this_case = to_case[rand(2)]
      arr[i] = letter.send(this_case)
    end
    arr.join("")
  end

  def self.spacify(str, spaces = 0)
    new_string = str
    spaces.times do
      new_string = new_string.split("").join(" ")
    end
    new_string
  end

end
