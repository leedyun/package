RSpec.describe "orders.create" do
  let(:client)   { ABBYY::Cloud.new settings }
  let(:settings) { { id: "foo", token: "bar" } }
  let(:path)     { "https://api.abbyy.cloud/v0/order" }

  let(:request) do
    {
      type:      "ht_professional",
      unit_type: "Words",
      currency:  "RUB",
      from:      "ru",
      to:        ["de"],
      files:     [{ id: "foo", token: "bar" }],
      category:  "Games > Lego"
    }
  end

  let(:response) do
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

  before do
    stub_request(:post, path)
      .with(basic_auth: %w(foo bar))
      .to_return status:  200,
                 headers: { "Content-Type" => "application/json" },
                 body:    JSON(response)
  end

  subject { client.orders.create request }

  context "with valid params" do
    it "sends a request to ABBYY Cloud API" do
      subject
      expect(a_request(:post, path)).to have_been_made
    end

    it "returns full order data" do
      expect(subject).to be_kind_of ABBYY::Cloud::Models::FullOrder
    end
  end

  context "without type:" do
    before { request.delete :type }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "without unit_type:" do
    before { request.delete :unit_type }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "without currency:" do
    before { request.delete :currency }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "without source language:" do
    before { request.delete :from }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "when label is too long:" do
    before { request[:label] = "a" * 81 }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "without target language:" do
    before { request[:to] = [] }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "with wrong translation type:" do
    before { request[:type] = "unknown" }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "with wrong cost type:" do
    before { request[:cost_type] = "Unknown" }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "with wrong unit type:" do
    before { request[:unit_type] = "Unknown" }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "without files:" do
    before { request[:files] = [] }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "with wrong file:" do
    before { request[:files] = [{ foo: "bar" }] }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "when API returned invalid order:" do
    before do
      stub_request(:post, path)
        .with(basic_auth: %w(foo bar))
        .to_return status:  200,
                   headers: { "Content-Type" => "application/json" },
                   body:    JSON(response.update(currency: nil))
    end

    it "raises TypeError" do
      expect { subject }.to raise_error(ABBYY::Cloud::TypeError)
    end
  end

  context "when API responded with error:" do
    before do
      stub_request(:post, path)
        .with(basic_auth: %w(foo bar))
        .to_return status:  500,
                   headers: { "Content-Type" => "application/json" },
                   body:    "Server error"
    end

    it "raises ResponseError" do
      expect { subject }.to raise_error(ABBYY::Cloud::ResponseError)
    end
  end
end
