require 'movingsign_api'

sign = MovingsignApi::Sign.new '/dev/ttyUSB0'

sign.show_text "Hello World"