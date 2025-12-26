require 'unit_spec_helper'

module AccessPolicyRails
  describe PolicyWrapper do
    subject{
      PolicyWrapper.new(policy)
    }

    let(:policy){
      double('policy', create?: true)
    }

    describe '#allow?'do
      it 'delegates to the policy object' do
        expect(subject.allow?(:create)).to be_truthy
      end
    end

  end
end