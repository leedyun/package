RSpec.describe ABBYY::Cloud::Models::TranslationLink do
  let(:data) do
    {
      source_file: {
        id: "foo",
        token: "bar",
        name: "ru.xml",
        language: "ru",
        chars_count: 107,
        words_count: 32,
        pages_count: 1,
        is_deleted: false
      },
      target_file: {
        id: "rab",
        token: "oof",
        name: "de.xml",
        language: "de",
        chars_count: 87,
        words_count: 22,
        pages_count: 1,
        is_deleted: false
      },
      started: "2016-03-13T10:00:00Z",
      delivered: "2019-03-14T11:00:00Z",
      status: "InProgress"
    }
  end

  subject { described_class.new(data) }

  it { is_expected.to be_kind_of ABBYY::Cloud::Model }

  context "without source_file:" do
    before { data.delete :source_file }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without target_file:" do
    before { data.delete :target_file }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without status:" do
    before { data.delete :status }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end
end
