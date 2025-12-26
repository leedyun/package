require "a1508ki_ika/version"

module A1508kiIka
  # Your code goes here...
  def self.getBMI(height, weight)
    weight / (height / 100.0  * height / 100.0)
  end
end

