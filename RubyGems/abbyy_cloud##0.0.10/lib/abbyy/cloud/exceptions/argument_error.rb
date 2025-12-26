# The exception to be risen when arguments of the operation
# mismatches ABBYY Cloud API spec
class ABBYY::Cloud
  class ArgumentError < ::ArgumentError
    def initialize(link, arguments, details)
      super <<-MESSAGE.gsub(/ +\|/, "")
        |The arguments of operation mismatch ABBYY Cloud API specification
        |  arguments:     #{arguments}
        |  specification: #{link}
        |  details:       #{details}
      MESSAGE
    end
  end
end
