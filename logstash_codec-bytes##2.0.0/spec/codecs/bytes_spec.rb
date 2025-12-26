require "spec_helper"
require "logstash/codecs/bytes"

describe LogStash::Codecs::Bytes do

  subject do
    LogStash::Codecs::Bytes.new({ "length" => 4 })
  end

  it "chunks the data into parts of given length" do
    data = "TestTest"

    subject.decode(data) do |event|
      expect(event.get("message").length).to eq(subject.length)
    end

  end

  it "creates an event for each complete chunk" do
    data = "TestTes"
    expected_count = data.bytes.count / subject.length
    count = 0

    subject.decode(data) { count += 1 }

    expect(count).to eq(expected_count)
  end

end
