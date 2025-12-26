# The exception to be risen when ABBYY Cloud API returned data that
# mismatches the specification
class ABBYY::Cloud
  class TypeError < ::TypeError
    def initialize(link, data, details)
      super <<-MESSAGE.gsub(/ +\|/, "")
        |The data returned by ABBYY Cloud API mismatch its specification
        |  returned data: #{data}
        |  specification: #{link}
        |  details:       #{details}
      MESSAGE
    end
  end
end
