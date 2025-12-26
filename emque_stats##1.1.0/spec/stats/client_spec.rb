describe Emque::Stats::Client do
  subject {
    producing_configuration = Emque::Producing::Configuration.new
    producing_configuration.publish_messages = false
    stats_configuration = Emque::Stats::Configuration.new
    stats_configuration.emque_producing_configuration = producing_configuration
    client = Emque::Stats::Client.new(stats_configuration)
    client
  }

  it "produces event" do
    subject.produce_track_event("signin")
  end

  it "produces count" do
    subject.produce_count("signin")
  end

  it "produces timers" do
    subject.produce_timer("timer", 10)
  end

  it "produces gauge" do
    subject.produce_gauge("gauge", 10)
  end
end
