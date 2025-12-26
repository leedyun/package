require File.dirname(__FILE__) + '/../test_helper'

class Widget
  include XML::Mapping
  time_node :work_start_on, 'WorkStartOn', :default_value => nil
end

class TimeNodeTest < Test::Unit::TestCase
  
  def setup
    @xml = <<-END
<Widget>
  <WorkStartOn>11:30:00</WorkStartOn>
</Widget>
  END

  end

  def test_load_from_xml
    item = Widget.load_from_xml(REXML::Document.new(@xml).root)
    assert_instance_of Time, item.work_start_on
    assert_equal Time.parse('11:30:00'), item.work_start_on
  end 

  def test_save_to_xml
    widget = Widget.new
    widget.work_start_on = Time.parse('11:30:00')
    assert_equal '<widget><WorkStartOn>11:30:00</WorkStartOn></widget>', widget.save_to_xml.to_s
  end

  def test_set_with_non_time_object
    widget = Widget.new
    widget.work_start_on = '11:30:00'
    assert_raise(RuntimeError){ widget.save_to_xml }
  end
end

