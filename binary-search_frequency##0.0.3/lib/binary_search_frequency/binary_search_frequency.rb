module BinarySearchFrequency
  def binary_frequency number
    left_index = left_binary_search(number, 0, size - 1)

    if left_index
      right_index = right_binary_search(number, left_index, size - 1)
      right_index - left_index + 1
    else
      0
    end
  end

  def bfrequency number
    binary_frequency number
  end

  def left_binary_search number, left, right
    if left <= right
      midpoint_index = (right + left) / 2
      midpoint_value = self[midpoint_index]

      return midpoint_index if midpoint_index.zero? && self[midpoint_index] == number
      if midpoint_value < number
        return midpoint_index + 1 if self[midpoint_index+1] == number
        left_binary_search number, midpoint_index + 1, right
      elsif midpoint_value >= number
        left_binary_search number, left, midpoint_index - 1
      end
    end
  end

  def right_binary_search number, left, right
    if left <= right
      midpoint_index = (right + left) / 2
      midpoint_value = self[midpoint_index]

      return midpoint_index if midpoint_index == size - 1 && self[midpoint_index] == number
      if midpoint_value <= number
        right_binary_search number, midpoint_index + 1, right
      elsif midpoint_value > number
        return midpoint_index - 1 if self[midpoint_index-1] == number
        right_binary_search number, left, midpoint_index - 1
      end
    end
  end
end