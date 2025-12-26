require 'spec_helper'

DISPLAY_SPEEDS = {
  :fastest => '1',
  :faster => '2',
  :normal => '3',
  :slow => '4',
  :slower => '5',
}

describe MovingsignApi::DisplaySpeed do
  describe '::parse' do
    it "Symbol" do
      DISPLAY_SPEEDS.keys.each do |key|
        expect(described_class.parse(key).key).to eq key
      end

      # invalid keys
      expect {described_class.parse(:invalid).key}.to raise_error(MovingsignApi::InvalidInputError)
      expect {described_class.parse(nil).key}.to raise_error(MovingsignApi::InvalidInputError)
    end
  end
end
