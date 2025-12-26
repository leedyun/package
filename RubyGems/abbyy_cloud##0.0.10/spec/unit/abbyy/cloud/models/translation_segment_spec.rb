RSpec.describe ABBYY::Cloud::Models::TranslationSegment do
  let(:data) do
    {
      id:   "foo",
      text: "to be or not to be",
      tags_transfer_data: [{ order: 1, position: 0 }]
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

  context "with invalid tags_transfer_data:" do
    before { data[:tags_transfer_data] = "foo" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid tag:" do
    before { data[:tags_transfer_data].first[:order] = nil }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end
end
