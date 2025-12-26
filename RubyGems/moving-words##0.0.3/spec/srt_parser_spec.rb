require 'spec_helper'

module MovingWords
  describe SrtParser do
    describe "#parse" do
      let(:parser) { SrtParser.new <<EOF
1
00:00:00,000 --> 00:00:13,000
[?Jazzy music playing?]

2
00:00:14,000 --> 00:00:16,000
In the previous lesson, we learned how to encode

3
00:00:16,000 --> 00:00:18,000
and embed a video into our page.

4
00:00:18,000 --> 00:00:23,000
In this lesson, we're going to learn about the JavaScript API for interacting with our videos
EOF
      }

      it "returns the correct number of blocks" do
        expect(parser.parse.length).to eq(4)
      end
    end

    describe "#parse_caption_block" do
      let(:parser) { SrtParser.new("") }

      let(:single_line) { 
        parser.parse_caption_block <<EOF
3
00:00:16,012 --> 00:00:18,293
and embed a video into our page.
EOF
      }

      let(:multi_line) { 
        parser.parse_caption_block <<EOF
3
00:00:16,012 --> 00:00:18,293
and embed a video into our page
and then embed another video for kicks.
EOF
      }

      it "parses the start_time correctly" do
        expect(single_line.start_time).to eq(16012)
      end

      it "parses the end_time correctly" do
        expect(single_line.end_time).to eq(18293)
      end

      it "handles single line content correctly" do
        expect(single_line.content).to eq("and embed a video into our page.")
      end

      it "handles multi-line content correctly" do
        expect(multi_line.content).to eq("and embed a video into our page\nand then embed another video for kicks.")
      end
    end
  end
end