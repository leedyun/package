RSpec.describe "orders.find" do
  let(:client) { ABBYY::Cloud.new id: "foo", token: "bar" }
  let(:path)   { "https://api.abbyy.cloud/v0/order/45" }
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

  subject { client.orders.find(45) }

  context "when API returned valid data:" do
    before do
      stub_request(:get, path)
        .with(basic_auth: %w(foo bar))
        .to_return status:  200,
                   headers: { "Content-Type" => "application/json" },
                   body:    JSON(response)
    end

    it "sends a request to ABBYY Cloud API" do
      subject
      expect(a_request(:get, path)).to have_been_made
    end

    it "returns full order data" do
      expect(subject).to be_kind_of ABBYY::Cloud::Models::FullOrder
    end
  end

  context "when API returned invalid order:" do
    before do
      stub_request(:get, path)
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
      stub_request(:get, path)
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
