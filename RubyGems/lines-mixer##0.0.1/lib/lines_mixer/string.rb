class String
  
  def mix_lines(number=1)
    lines = self.lines.map(&:chomp)
    number_of_lines = lines.size
    output = []
    x = 0
    while x < number_of_lines
      output << lines.slice(x, number)
      x += number
    end
    output.shuffle!
    output = output.map do |o|
      o.join("\n")
    end
    return output.join("\n")
  end
  
end