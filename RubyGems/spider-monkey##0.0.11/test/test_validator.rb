require 'minitest/autorun'
require 'spider_monkey'

class SpiderMonkeyValidatorTest < Minitest::Test
  def test_validate_options
    url = "http://example.com/image.jpg"
    
    options = {width: 150, height: 85, resize_method: :crop, resize_gravity: "Center", density: 300, quality: 90, thumbnail: true, source_url: url, key: "asdf"}
    validator = SpiderMonkey::Validator.new(options)
    response = validator.validate_options
    assert response[:passed]
    assert response[:recoverable]

    options = {extra_params: "foobar", width: 150, height: 85, resize_method: :crop, resize_gravity: "Center", density: 300, quality: 90, thumbnail: true, source_url: url, key: "asdf"}
    validator = SpiderMonkey::Validator.new(options)
    response = validator.validate_options
    refute response[:passed]
    assert response[:recoverable]
    
    
    options = {width: nil, height: 85, resize_method: :crop, resize_gravity: "Center", density: 300, quality: 90, thumbnail: true, source_url: url, key: "asdf"}
    validator = SpiderMonkey::Validator.new(options)
    response = validator.validate_options
    refute response[:passed]
    refute response[:recoverable]
    
    options = {height: 85, resize_method: :crop, resize_gravity: "Center", density: 300, quality: 90, thumbnail: true, source_url: url, key: "asdf"}
    validator = SpiderMonkey::Validator.new(options)
    response = validator.validate_options
    refute response[:passed]
    refute response[:recoverable]
    
    options = {width: "foo", height: 85, resize_method: :crop, resize_gravity: "Center", density: 300, quality: 90, thumbnail: true, source_url: url, key: "asdf"}
    validator = SpiderMonkey::Validator.new(options)
    response = validator.validate_options
    refute response[:passed]
    refute response[:recoverable]
    
    options = {}
    validator = SpiderMonkey::Validator.new(options)
    response = validator.validate_options
    refute response[:passed]
    refute response[:recoverable]
    
    options = {width: 150, height: 85, source_url: url, key: "asdf"}
    validator = SpiderMonkey::Validator.new(options)
    response = validator.validate_options
    assert response[:passed]
    assert response[:recoverable]
  end
  
  def test_is_integer?
    validator = SpiderMonkey::Validator.new
    assert validator.is_integer?(3)
    
    refute validator.is_integer?("300")
    refute validator.is_integer?("3")
    refute validator.is_integer?(3.0)
    refute validator.is_integer?("3.0")
    refute validator.is_integer?("3oo")
    refute validator.is_integer?("")
    refute validator.is_integer?(nil)
    refute validator.is_integer?("thirty")
  end
  
  def test_is_integer_like?
    validator = SpiderMonkey::Validator.new
    assert validator.is_integer_like?(3)
    assert validator.is_integer_like?("300")
    assert validator.is_integer_like?("3")
    
    refute validator.is_integer_like?(3.0)
    refute validator.is_integer_like?("3.0")
    refute validator.is_integer_like?("3oo")
    refute validator.is_integer_like?("")
    refute validator.is_integer_like?(nil)
    refute validator.is_integer_like?("thirty")
  end
  
  def test_is_string?
    validator = SpiderMonkey::Validator.new
    assert validator.is_string?("asdf")
    assert validator.is_string?("14")
    
    refute validator.is_string?(14)
  end
  
  def test_is_boolean?
    validator = SpiderMonkey::Validator.new
    assert validator.is_boolean?(true)
    assert validator.is_boolean?(false)
    
    refute validator.is_boolean?("false")
    refute validator.is_boolean?("true")
    refute validator.is_boolean?("asdf")
    refute validator.is_boolean?(0)
    refute validator.is_boolean?(1)
  end
  
  def test_is_color?
    validator = SpiderMonkey::Validator.new
    
    assert validator.is_color?("blue")
    assert validator.is_color?(:blue)
    assert validator.is_color?("#0000FF")
    assert validator.is_color?("#0000FF00")
    assert validator.is_color?("rgb(0,0,255)")
    assert validator.is_color?("rgba(0,0,255, 0.5)")
    
    refute validator.is_color?("#asdf")
    refute validator.is_color?("#1234567")
    refute validator.is_color?("#123456HH")
    refute validator.is_color?("rgba(0,0,255)") #said rgba but didn't include alpha
    refute validator.is_color?("rgb(0,0,255, 0.5)")
    refute validator.is_color?("rgb(0)")
    refute validator.is_color?("rgb(blue)")
  end
  
  def test_is_alpha?
    validator = SpiderMonkey::Validator.new
    
    assert validator.is_alpha?("Background")
    assert validator.is_alpha?("Remove")
    
    refute validator.is_alpha?("#asdf")
    refute validator.is_alpha?("asdf")
    refute validator.is_alpha?(nil)
    refute validator.is_alpha?("")
  end
  
  def test_is_gravity?
    validator = SpiderMonkey::Validator.new
    gravities = %w(
      northwest
      north
      northeast
      west
      center
      east
      southwest
      south
      southeast
    )
    
    gravities.each do |g|
      assert validator.is_gravity?(g)
    end
    
    assert validator.is_gravity?(:center)
    assert validator.is_gravity?("Center")
    
    assert validator.is_gravity?("NorthWest")
    assert validator.is_gravity?("Northwest")
    
    refute validator.is_gravity?("Middle")
    refute validator.is_gravity?("Purple")
    refute validator.is_gravity?("foobar")
  end
  
  def test_is_colorspace?
    validator = SpiderMonkey::Validator.new
    colorspaces = %w(
      CIELab
      CMY
      CMYK
      Gray
      HCL
      HCLp
      HSB
      HSI
      HSL
      HSV
      HWB
      Lab
      LCH
      LCHab
      LCHuv
      LMS
      Log
      Luv
      OHTA
      Rec601Luma
      Rec601YCbCr
      Rec709Luma
      Rec709YCbCr
      RGB
      scRGB
      sRGB
      Transparent
      XYZ
      xyY
      YCbCr
      YDbDr
      YCC
      YIQ
      YPbPr
      YUV
    )
    
    colorspaces.each do |g|
      assert validator.is_colorspace?(g)
    end
    
    refute validator.is_colorspace?("srgb")
    refute validator.is_colorspace?("Weee")
    refute validator.is_colorspace?("")
    refute validator.is_colorspace?("cmyk")
  end
  
  def test_is_percent?
    validator = SpiderMonkey::Validator.new
    # String, with a percent sign, and an integer
    
    assert validator.is_percent? "4%"
    assert validator.is_percent? "40%"
    assert validator.is_percent? "14%"
    assert validator.is_percent? "154%"
    
    refute validator.is_percent? "154"
    refute validator.is_percent? "%"
    refute validator.is_percent? 14
  end
  
  def test_is_url?
    validator = SpiderMonkey::Validator.new
    
    assert validator.is_url?("http://asdf.com/asdf")
    assert validator.is_url?("https://asdf.com/asdf")
    
    refute validator.is_url?("asdf")
    refute validator.is_url?("asdfasdfasdf")
    refute validator.is_url?("https://")
  end
  
  def test_is_resize_method?
    validator = SpiderMonkey::Validator.new
    assert validator.is_resize_method? :crop
    assert validator.is_resize_method? :fit
    assert validator.is_resize_method? "crop"
    
    refute validator.is_resize_method? :magic
    refute validator.is_resize_method? "magic"
  end
  
  def test_is_source?
    validator = SpiderMonkey::Validator.new
    assert validator.is_source?({key: "foo", bucket: "bar"})
    assert validator.is_source?({url: "http://fizbam.com"})
    
    assert validator.is_source?({source_key: "foo", source_bucket: "bar"}, "source")
    assert validator.is_source?({source_url: "http://fizbam.com"}, "source")
    
    refute validator.is_source?({key: "foo", bucket: "bar"}, "source")
    refute validator.is_source?({url: "http://fizbam.com"}, "source")
    
    
    refute validator.is_source?({url: "fizbam"})
    refute validator.is_source?({url: "fizbam", key: "asdf"})
    refute validator.is_source?({url: "fizbam", bucket: "fsda"})
    refute validator.is_source?({key: "fizbam", bucket: ""})
    refute validator.is_source?({key: "", bucket: "fsda"})
    refute validator.is_source?({key: "asdf"})
    refute validator.is_source?({bucket: "asdf"})
    refute validator.is_source?({key: "asdf", bucket: nil})
    refute validator.is_source?({key: nil, bucket: "asdf"})
    refute validator.is_source?({})
  end
end