require 'spec_helper'


ALIGN_MODES = {
  :left => '1',
  :right => '3',
  :center => '2',
}

describe MovingsignApi::AlignMode do
  describe '::parse' do
    it "Symbol" do
      # valid keys
      ALIGN_MODES.keys.each do |key|
        expect(described_class.parse(key).key).to eq key
      end

      # invalid keys
      expect {described_class.parse(:invalid).key}.to raise_error(MovingsignApi::InvalidInputError)
      expect {described_class.parse(nil).key}.to raise_error(MovingsignApi::InvalidInputError)
    end

    it 'Code' do

    end

  end
end