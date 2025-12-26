RSpec.describe ABBYY::Cloud::Models::SourceTag do
  let(:data) { { number: 1, type: "Start", position: 0 } }

  subject { described_class.new(data) }

  it { is_expected.to be_kind_of ABBYY::Cloud::Model }
  its(:to_h) { is_expected.to eq data }

  context "with invalid number:" do
    before { data[:number] = "foo" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without number:" do
    before { data.delete :number }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid type:" do
    before { data[:type] = "foo" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without type:" do
    before { data.delete :type }

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
