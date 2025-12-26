require 'spec_helper'

describe MovingsignApi::SenderReceiverAddress do
  describe '::parse' do
    it "Integer" do
      # valid broadcast address
      expect(described_class.parse(0).to_s).to eq '00'
      expect(described_class.parse(0)).to be_broadcast

      expect(described_class.parse(3).to_s).to eq '03'

      # valid pc address
      expect(described_class.parse(255).to_s).to eq 'FF'
      expect(described_class.parse(255)).to be_pc

      # out of range
      expect { described_class.parse(-1) }.to raise_error(MovingsignApi::InvalidInputError)
      expect { described_class.parse(256) }.to raise_error(MovingsignApi::InvalidInputError)
    end

    it "Symbols :pc and :broadcast" do
      expect(described_class.parse(:broadcast).to_s).to eq '00'
      expect(described_class.parse(:broadcast)).to be_broadcast

      expect(described_class.parse(:pc).to_s).to eq 'FF'
      expect(described_class.parse(:pc)).to be_pc

      expect { described_class.parse(:invalid) }.to raise_error(MovingsignApi::InvalidInputError)
    end

    it 'String' do
      # valid broadcast address
      expect(described_class.parse('00').to_s).to eq '00'
      expect(described_class.parse('00')).to be_broadcast

      expect(described_class.parse('0a').to_s).to eq '0A'

      # valid pc address
      expect(described_class.parse('ff').to_s).to eq 'FF'
      expect(described_class.parse('FF').to_s).to eq 'FF'
      expect(described_class.parse('FF')).to be_pc

      # valid with wildcard
      expect(described_class.parse('1?').to_s).to eq '1?'
      expect(described_class.parse('?5').to_s).to eq '?5'

      # invalid (only one character)
      expect { described_class.parse('?') }.to raise_error(MovingsignApi::InvalidInputError)
      expect { described_class.parse('0') }.to raise_error(MovingsignApi::InvalidInputError)

      # invalid (out of hex range)
      expect { described_class.parse('?Z') }.to raise_error(MovingsignApi::InvalidInputError)
    end
  end

  it "#to_bytes" do
    expect(described_class.parse(:pc).to_bytes).to eq [0x46, 0x46]
    expect(described_class.parse(3).to_bytes).to eq [0x30, 0x33]
  end
end