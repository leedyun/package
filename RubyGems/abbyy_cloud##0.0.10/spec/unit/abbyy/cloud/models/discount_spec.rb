RSpec.describe ABBYY::Cloud::Models::Discount do
  let(:data) { { discount_type: "TMTextMatch", discount: 0.01 } }

  subject { described_class.new(data) }

  it { is_expected.to be_kind_of ABBYY::Cloud::Model }
  its(:to_h) { is_expected.to eq data }

  context "with invalid discount_type:" do
    before { data[:discount_type] = "Unknown" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without discount_type:" do
    before { data.delete :discount_type }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without discount:" do
    before { data.delete :discount }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end
end
