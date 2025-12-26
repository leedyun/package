require 'a1616ts_gem/version'

module A1616tsGem
  def self.break_even_point(fixed_cost, variable_cost, sales_result)
    return (fixed_cost / (1 - variable_cost / sales_result)).round
  end
end
