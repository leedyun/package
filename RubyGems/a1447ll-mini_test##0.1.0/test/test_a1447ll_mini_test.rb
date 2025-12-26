require 'minitest_helper'

class TestA1447llMiniTest < MiniTest::Unit::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::A1447llMiniTest::VERSION
  end

  def setup
    @my_class = ::A1447llMiniTest::MyClass.new
  end
  
  def test_odd?
    assert_equal true, @my_class.odd?(1)
    assert_equal false, @my_class.odd?(2)
  end

  def test_check_number?
    assert_equal true, @my_class.check_number?(1000)
    assert_equal false, @my_class.check_number?(9999)
    assert_equal false, @my_class.check_number?(10000)
    assert_equal false, @my_class.check_number?(999)
  end

  def test_enough_length?
    assert_equal true, @my_class.enough_length?("abc")
    assert_equal true, @my_class.enough_length?("12345678")
    assert_equal false, @my_class.enough_length?("12")
    assert_equal false, @my_class.enough_length?("123456789")
  end

  def test_divide
    assert_equal 5, @my_class.divide(10, 2)
    assert_equal 0, @my_class.divide(1, 2)
    assert_raises ZeroDivisionError do
      @my_class.divide(1, 0)
    end
  end
  
  def test_fizz_buzz
    assert_equal "FizzBuzz", @my_class.fizz_buzz(15)
    assert_equal "Fizz", @my_class.fizz_buzz(3)
    assert_equal "Buzz", @my_class.fizz_buzz(5)
    assert_equal nil, @my_class.fizz_buzz(1)
  end
  
  def test_hello
    assert_equal "Hello, Bao Linh!", @my_class.hello("bAo LiNH")
  end
   
end
