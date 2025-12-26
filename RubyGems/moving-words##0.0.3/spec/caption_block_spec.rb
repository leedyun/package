require 'spec_helper'

module MovingWords
  describe CaptionBlock do
    describe ".human_offset" do
      it "handles times with minutes without showing hours" do
        expect(CaptionBlock.human_offset(132212)).to eq("2:12")
      end

      it "handles times over 6 minutes without wrapping" do
        expect(CaptionBlock.human_offset(728419)).to eq("12:08")
      end

      it "shows milliseconds when requested" do
        expect(CaptionBlock.human_offset(132212, milliseconds: true)).to eq("2:12.212")
      end

      it "shows hours when they're needed" do
        expect(CaptionBlock.human_offset(11075307)).to eq("3:04:35")
      end
    end
  end
end