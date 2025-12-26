describe Emque::Stats do
  describe "#configure" do
    before do
      Emque::Stats.configure do |config|
        emque_configuration = Emque::Producing::Configuration.new
        emque_configuration.app_name = "emque_stats"
        config.emque_producing_configuration = emque_configuration
      end
    end

    it "has a configuration" do
      expect(
        Emque::Stats.configuration.emque_producing_configuration.app_name
      ).to eq "emque_stats"
    end
  end

  describe "#count" do
    subject {
      Emque::Stats.configure do |config|
      end
      Emque::Stats.client
    }

    it "by default, produces a count of 1" do
      expect(subject).to receive(:produce_count).with("an.event", 1)
      Emque::Stats.count("an.event")
    end

    it "produces an arbitrary count" do
      expect(subject).to receive(:produce_count).with("an.event", 5)
      Emque::Stats.count("an.event", 5)
    end
  end
end
