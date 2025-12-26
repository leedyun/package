require 'minitest/autorun'
require 'a1412tk_bmi'

class A1412tkBmiTest < Minitest::Test

  def test_calc
    assert_equal 21.6, A1412tkBmi.calc(180, 70)
  end

  def test_calc_float_height
    assert_equal 21.5, A1412tkBmi.calc(180.4, 70)
  end

  def test_calc_float_weight
    assert_equal 21.8, A1412tkBmi.calc(180, 70.6)
  end

  def test_calc_float_both
    assert_equal 21.7, A1412tkBmi.calc(180.4, 70.6)
  end

end
