require 'spec_helper'


DISPLAY_MODES = {
  :auto => 'A',
  :flash => 'B',
  :hold => 'C',
  :interlock => 'D',
  :rolldown => 'E',
  :rollup => 'F',
  :rollin => 'G',
  :rollout => 'H',
  :rollleft => 'I',
  :rollright => 'J',
  :rotate => 'K',
  :slide => 'L',
  :snow => 'M',
  :sparkle => 'N',
  :spray => 'O',
  :starburst => 'P',
  :switch => 'Q',
  :twinkle => 'R',
  :wipedown => 'S',
  :wipeup => 'T',
  :wipein => 'U',
  :wipeout => 'V',
  :wipeleft => 'W',
  :wiperight => 'X',
  :cyclecolor => 'Y',
  :clock => 'Z',
}

describe MovingsignApi::DisplayMode do
  describe '::parse' do
    it "Symbol" do
      # All valid keys
      DISPLAY_MODES.keys.each do |key|
        expect(described_class.parse(key).key).to eq key
      end

      # invalid keys
      expect {described_class.parse(:invalid).key}.to raise_error(MovingsignApi::InvalidInputError)
      expect {described_class.parse(:+).key}.to raise_error(MovingsignApi::InvalidInputError)
      expect {described_class.parse(nil).key}.to raise_error(MovingsignApi::InvalidInputError)
    end

    it "ASCII Code" do
      # All valid ASCII codes
      DISPLAY_MODES.each_pair do |key, code|
        expect(described_class.parse(code).key).to eq key
      end

      expect {described_class.parse('0').key}.to raise_error(MovingsignApi::InvalidInputError)
      expect {described_class.parse('z').key}.to raise_error(MovingsignApi::InvalidInputError)
    end
  end
end
