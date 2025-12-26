RSpec.describe ABBYY::Cloud::Models::TransferData do
  let(:data) { { order: 1, position: 0 } }

  subject { described_class.new(data) }

  it { is_expected.to be_kind_of ABBYY::Cloud::Model }
  its(:to_h) { is_expected.to eq data }

  context "with invalid order:" do
    before { data[:order] = "foo" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without order:" do
    before { data.delete :order }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid position:" do
    before { data[:position] = "foo" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without position:" do
    before { data.delete :position }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end
end
