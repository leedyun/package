RSpec.describe ABBYY::Cloud::Models::Direction do
  let(:data) { { source: "en-Br", target: "ru" } }

  subject { described_class.new(data) }

  it { is_expected.to be_kind_of ABBYY::Cloud::Model }
  its(:to_h) { is_expected.to eq data }

  context "with invalid source:" do
    before { data[:source] = "2" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without source:" do
    before { data.delete :source }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid target:" do
    before { data[:target] = "r" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without target:" do
    before { data.delete :target }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end
end
