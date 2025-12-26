require 'spec_helper'

describe ActsAsExplorable::Element::In do

  subject { ActsAsExplorable::Element::In }
  let (:element) { ActsAsExplorable::Element }

  it 'should return a dynamic filter element' do
    expect(element.build(:in, 'test in:first_name', Player)).to be_instance_of(subject)
  end

end
