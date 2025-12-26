# frozen_string_literal: true

RSpec.describe Slack::Messenger::PayloadMiddleware::FormatMessage do
  it "passes the text through linkformatter with options[:formats]" do
    subject = described_class.new(:messenger, formats: [:html])
    expect(Slack::Messenger::Util::LinkFormatter).to receive(:format)
      .with("hello", formats: [:html])
    subject.call(text: "hello")

    subject = described_class.new(:messenger)
    expect(Slack::Messenger::Util::LinkFormatter).to receive(:format)
      .with("hello", formats: %i[html markdown])
    subject.call(text: "hello")

    subject = described_class.new(:messenger, formats: [:markdown])
    expect(Slack::Messenger::Util::LinkFormatter).to receive(:format)
      .with("hello", formats: [:markdown])
    subject.call(text: "hello")
  end

  it "returns the payload unmodified if not :text key" do
    payload = { foo: :bar }
    subject = described_class.new(:messenger)

    expect(subject.call(payload)).to eq payload
  end
end
