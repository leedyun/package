RSpec.describe ABBYY::Cloud::Models::Engine do
  let(:data) do
    {
      name: "Bing",
      languages: %w(ru en),
      translation_directions: [{ source: "ru", target: "en" }]
    }
  end

  subject { described_class.new(data) }

  it { is_expected.to be_kind_of ABBYY::Cloud::Model }
  its(:to_h) { is_expected.to eq data }

  context "without name:" do
    before { data.delete :name }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid languages:" do
    before { data[:languages] = "wrong" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid language:" do
    before { data[:languages] = %w(en r) }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without languages:" do
    before { data.delete :languages }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid translation_directions:" do
    before { data[:translation_directions] = "wrong" }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "with invalid translation_direction:" do
    before { data[:translation_directions] = [{ source: "r", target: "en" }] }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without translation_direction:" do
    before { data.delete :translation_directions }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end
end
