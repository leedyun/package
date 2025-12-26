RSpec.describe ABBYY::Cloud::Models::UnitPrice do
  let(:data) { { unit_type: "Words", currency: "USD", amount: 0.03 } }

  subject { described_class.new(data) }

  it { is_expected.to be_kind_of ABBYY::Cloud::Model }
  its(:to_h) { is_expected.to eq data }

  context "with invalid unit_type:" do
    before { data[:unit_type] = "Miles" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without unit_type:" do
    before { data.delete :unit_type }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid currency:" do
    before { data[:currency] = "usd" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without currency:" do
    before { data.delete :currency }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without amount:" do
    before { data.delete :amount }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end
end
