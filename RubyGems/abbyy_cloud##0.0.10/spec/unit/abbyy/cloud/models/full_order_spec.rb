RSpec.describe ABBYY::Cloud::Models::FullOrder do
  let(:data) do
    {
      translations: [
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
          progress: 10,
          status: "InProgress"
        }
      ],
      id: "qux",
      number: 1924,
      email: "user@example.com",
      type: "ht_professional",
      from: "ru",
      to: ["de"],
      is_layout_required: true,
      label: "baz",
      payment_type: "External",
      unit_type: "Words",
      unit_count: 32,
      units_count: {
        format: 1,
        type:   2
      },
      currency: "RUB",
      amount: 100.0,
      deadline: "2019-01-23T10:00:00Z",
      payment_provider: "CloudPayments",
      is_manual_estimation: true,
      created: "2019-02-10T12:00:00Z",
      started: "2016-03-13T10:00:00Z",
      delivered: "2019-03-14T11:00:00Z",
      progress: 10,
      status: "InProgress",
      approval_required: true,
      deleted: nil,
      is_deleted: false,
      statistics: {
        documents_count: 1,
        pages_count: 1,
        words_count: 32,
        chars_count: 103
      }
    }
  end

  subject { described_class.new(data) }

  it { is_expected.to be_kind_of ABBYY::Cloud::Model }

  context "without translations:" do
    before { data.delete :translations }

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

  context "without number:" do
    before { data.delete :number }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without email:" do
    before { data.delete :email }

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

  context "without from:" do
    before { data.delete :from }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without to:" do
    before { data.delete :to }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without payment_type:" do
    before { data.delete :payment_type }

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

  context "without created:" do
    before { data.delete :created }

    it "fails" do
      expect { subject }.to raise_error(StandardError)
    end
  end

  context "without progress:" do
    before { data.delete :progress }

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
