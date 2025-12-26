RSpec.describe ABBYY::Cloud::Models::Error do
  let(:data) do
    {
      request_id: "foo",
      error: "bar",
      error_description: "baz",
      model_state: {
        id:    1,
        value: "qux"
      }
    }
  end

  subject { described_class.new(data) }

  it { is_expected.to be_kind_of ABBYY::Cloud::Model }
  its(:to_h) { is_expected.to eq data }

  context "without params" do
    let(:data) { {} }
    it { is_expected.to be_kind_of ABBYY::Cloud::Model }
  end

  context "with invalid request_id:" do
    before { data[:request_id] = 1 }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid error:" do
    before { data[:error] = 1 }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid error_description:" do
    before { data[:error_description] = 1 }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid model_state:" do
    before { data[:model_state] = 1 }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end
end
