require 'spec_helper'

describe ActsAsExplorable::Element::DynamicFilter do

  subject { ActsAsExplorable::Element::DynamicFilter }
  let (:element) { ActsAsExplorable::Element }

  it 'should return a dynamic filter element' do
    expect(element.build(:position, 'position:gk,mf,fw', Player)).to be_instance_of(subject)
  end

  it 'should filter by position' do
    create(:goalkeeper)
    create(:forward)

    expect(Player.search('position:gk').count).to eq(1)
  end

end
