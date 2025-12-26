RSpec.describe "prices.details" do
  let(:client) { ABBYY::Cloud.new id: "foo", token: "bar" }
  let(:price) do
    {
      id:          "foo",
      account_id:  "bar",
      type:        "qux",
      from:        "ru",
      to:          "en",
      unit_prices: [{ unit_type: "Words", currency: "USD", amount: 0.03 }],
      discounts:   [{ discount_type: "TMTextMatch", discount: 0.01 }],
      created:     Time.parse("2017-03-09 18:19")
    }
  end

  before do
    stub_request(:get, //)
      .with(basic_auth: %w(foo bar))
      .to_return status:  200,
                 headers: { "Content-Type" => "application/json" },
                 body:    JSON.generate(Array.new(taken) { price })
  end

  subject { client.prices.details skip: 0, take: take }

  context "when take not exceeds 1_000:" do
    let(:take)  { 1_000 }
    let(:taken) { 1_000 }

    it "sends a request to ABBYY Cloud API" do
      subject
      expect(a_request(:get, "https://api.abbyy.cloud/v0/prices/details?skip=0&take=1000")).to have_been_made.once
    end

    it "returns list of prices" do
      expect(subject.count).to eq 1_000
      expect(subject.first.to_h).to eq price
    end
  end

  context "when take exceeds 1_000:" do
    let(:take)  { 2_000 }
    let(:taken) { 1_000 }

    it "sends several requests to ABBYY Cloud API" do
      subject
      expect(a_request(:get, "https://api.abbyy.cloud/v0/prices/details?skip=0&take=1000")).to have_been_made.once
      expect(a_request(:get, "https://api.abbyy.cloud/v0/prices/details?skip=1000&take=1000")).to have_been_made.once
    end

    it "returns list of prices" do
      expect(subject.count).to eq 2_000
    end
  end

  context "when number of prices is less than take option:" do
    let(:take)  { 2_000 }
    let(:taken) { 900 }

    it "sends necessary requests only" do
      subject
      expect(a_request(:get, "https://api.abbyy.cloud/v0/prices/details?skip=0&take=1000")).to have_been_made.once
      expect(a_request(:get, "https://api.abbyy.cloud/v0/prices/details?*")).not_to have_been_made
    end

    it "returns list of prices" do
      expect(subject.count).to eq 900
    end
  end
end
