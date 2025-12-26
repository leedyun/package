require 'rjb'
require 'rjb/list'

    ja = Rjb::import('java.util.ArrayList')
    a = ja.new
    a.add(1)
    a.add(2)
    a.add(3)
    n = 1
    a.each {|x|p x.intValue}
p n
