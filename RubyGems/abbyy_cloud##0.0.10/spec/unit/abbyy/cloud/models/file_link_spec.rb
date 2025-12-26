RSpec.describe ABBYY::Cloud::Models::FileLink do
  let(:data) do
    {
      id: "foo",
      token: "bar",
      name: "baz.txt",
      language: "fr",
      is_deleted: true,
      chars_count: 3204,
      words_count: 132,
      pages_count: 3
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

  context "without token:" do
    before { data.delete :token }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without name:" do
    before { data.delete :name }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without language:" do
    before { data.delete :language }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end
end
