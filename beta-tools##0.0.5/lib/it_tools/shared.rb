require 'xmlsimple'
module SharedTool
  class RegularExpression
    def has_string(data, regex)
      if first_occurence data, regex != ""
        return true
      end
      return false
    end
    def first_occurrence(data, regex)
      if data =~ regex
        return $1
      end 
      return ""
    end
  end
end
class String
  def remove_non_ascii(replacement="") 
    self.force_encoding('ASCII-8BIT').gsub(/[\x80-\xff]/,replacement)
  end
end
