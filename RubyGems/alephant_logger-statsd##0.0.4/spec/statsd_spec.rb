require "alephant/logger/statsd"

describe Alephant::Logger::Statsd do
  subject { described_class }
  let(:server) do
    instance_double(
      ::Statsd,
      :increment  => true,
      :timing     => true,
      :namespace= => true
    )
  end

  before do
    allow(::Statsd).to receive(:new) { server }
  end

  describe ".new" do
    context "default config" do
      let(:config) do
        {
          :host      => "localhost",
          :port      => 8125,
          :namespace => "statsd"
        }
      end

      specify do
        subject.new
        expect(::Statsd).to have_received(:new).once.with(
          config[:host],
          config[:port]
        )
      end

      specify do
        subject.new
        expect(server).to have_received(:namespace=).once.with(
          config[:namespace]
        )
      end
    end

    context "custom config" do
      let(:config) do
        {
          :host      => "192.168.59.103",
          :port      => 1234,
          :namespace => "batman"
        }
      end

      specify do
        subject.new config
        expect(::Statsd).to have_received(:new).once.with(
          config[:host],
          config[:port]
        )
      end

      specify do
        subject.new config
        expect(server).to have_received(:namespace=).once.with(
          config[:namespace]
        )
      end
    end
  end

  describe "#increment" do
    let(:driver) { subject.new }
    let(:key) { "batman" }

    context "default interval" do
      specify do
        driver.increment(key).join
        expect(server).to have_received(:increment).once.with(key, 1)
      end
    end

    context "custom interval" do
      let(:interval) { 10 }

      specify do
        driver.increment(key, interval).join
        expect(server).to have_received(:increment).once.with(key, interval)
      end
    end
  end

  describe "#metric" do
    let(:driver) { subject.new }
    let(:key) { "batman" }

    context "default interval" do
      specify do
        driver.metric(key).join
        expect(server).to have_received(:increment).once.with(key, 1)
      end
    end

    context "custom interval" do
      let(:interval) { 10 }

      specify do
        driver.metric(key, interval).join
        expect(server).to have_received(:increment).once.with(key, interval)
      end
    end
  end

  describe "#timing" do
    let(:driver) { subject.new }
    let(:key) { "batman" }
    let(:time) { 512 }

    context "default interval" do
      specify do
        driver.timing(key, time).join
        expect(server).to have_received(:timing).once.with(key, time, 1)
      end
    end

    context "custom interval" do
      let(:interval) { 10 }

      specify do
        driver.timing(key, time, interval).join
        expect(server).to have_received(:timing).once.with(key, time, interval)
      end
    end
  end
end
