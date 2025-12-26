require 'spec_helper'

describe MovingsignApi::SetSoundCommand do
  describe "sound on" do
    subject { MovingsignApi::SetSoundCommand.new(true) }

    it "#subcommand_payload_bytes" do
      expect(subject.subcommand_payload_bytes).to eq [0x31]
    end
  end

  describe "sound off" do
    subject { MovingsignApi::SetSoundCommand.new(false) }

    it "#subcommand_payload_bytes" do
      expect(subject.subcommand_payload_bytes).to eq [0x30]
    end
  end
end