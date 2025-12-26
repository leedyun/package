require 'spec_helper'

describe ActsAsExplorable::Element do

  subject { ActsAsExplorable::Element }

  describe '.build' do
    it 'should be callable' do
      expect(subject).to respond_to(:build)
    end

    it 'should create an element' do
      expect(ActsAsExplorable::Element.build(:position, 'position:gk', Player)).to be_instance_of(ActsAsExplorable::Element::DynamicFilter)
    end
  end
end
