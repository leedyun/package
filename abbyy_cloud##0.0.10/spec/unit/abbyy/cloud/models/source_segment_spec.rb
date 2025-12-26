RSpec.describe ABBYY::Cloud::Models::SourceSegment do
  let(:data) do
    {
      text: "to be or not to be",
      tags: [{ number: 1, type: "Start", position: 0 }]
    }
  end

  subject { described_class.new(data) }

  it { is_expected.to be_kind_of ABBYY::Cloud::Model }
  its(:to_h) { is_expected.to eq data }

  context "without text:" do
    before { data.delete :text }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid tags:" do
    before { data[:tags] = "foo" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid tag:" do
    before { data[:tags].first[:type] = "foo" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end
end
