RSpec.describe ABBYY::Cloud::Models::Price do
  let(:data) do
    {
      id:          "foo",
      account_id:  "bar",
      type:        "qux",
      from:        "ru",
      to:          "en",
      unit_prices: [{ unit_type: "Words", currency: "USD", amount: 0.03 }],
      discounts:   [{ discount_type: "TMTextMatch", discount: 0.01 }],
      created:     Time.now
    }
  end

  subject { described_class.new(data) }

  it { is_expected.to be_kind_of ABBYY::Cloud::Model }
  its(:to_h) { is_expected.to eq data }

  context "without id:" do
    before { data.delete :id }

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

  context "without source language:" do
    before { data.delete :from }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without target language:" do
    before { data.delete :to }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid unit_prices:" do
    before { data[:unit_prices] = "foo" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid unit_price:" do
    before { data[:unit_prices] = [{ id: "foo" }] }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without unit_prices:" do
    before { data.delete :unit_prices }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid discounts:" do
    before { data[:discounts] = "foo" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid discount:" do
    before { data[:discounts] = [{ id: "foo" }] }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without discounts:" do
    before { data.delete :discounts }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end
end
