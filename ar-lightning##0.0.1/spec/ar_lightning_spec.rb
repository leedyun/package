require 'spec_helper'

describe 'item' do
  subject { Item.create(field_1:'boo', field_2:'hoo', field_3:1) }
  specify { subject.field_1.should == 'boo' }
  specify { subject.field_2.should == 'hoo' }
  specify { subject.field_3.should == 1 }
end
