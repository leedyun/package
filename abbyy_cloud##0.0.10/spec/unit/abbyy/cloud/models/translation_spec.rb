RSpec.describe ABBYY::Cloud::Models::Translation do
  let(:data) { { id: "foo", translation: "bar" } }

  subject { described_class.new(data) }

  it { is_expected.to be_kind_of ABBYY::Cloud::Model }
  its(:to_h) { is_expected.to eq data }

  context "with invalid id:" do
    before { data[:id] = 1 }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without id:" do
    before { data.delete :id }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid translation:" do
    before { data[:translation] = 1 }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without translation:" do
    before { data.delete :translation }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end
end
