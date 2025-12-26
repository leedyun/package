add_me = lambda { |x,y| puts x + y }
func2 add_me
multiply_me = lambda { |x,y| puts x * y }
func2 multiply_me

def func2(func)
  func.call 2,3
end

