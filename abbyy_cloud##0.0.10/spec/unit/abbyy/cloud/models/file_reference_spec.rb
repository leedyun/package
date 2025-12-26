RSpec.describe ABBYY::Cloud::Models::FileReference do
  let(:data) { { id: "foo", token: "bar" } }

  subject { described_class.new(data) }

  it { is_expected.to be_kind_of ABBYY::Cloud::Model }
  its(:to_h) { is_expected.to eq data }

  context "without id:" do
    before { data.delete :id }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without token:" do
    before { data.delete :token }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end
end
