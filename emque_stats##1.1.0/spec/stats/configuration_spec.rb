describe Emque::Stats::Configuration do
  subject { Emque::Stats::Configuration.new }

  it "emque_producing_configuration is nil by default" do
    expect(subject.emque_producing_configuration).to eq nil
  end

  it "allows emque_producing_configuration to be overwritten" do
    subject.emque_producing_configuration = Emque::Producing::Configuration.new
    expect(subject.emque_producing_configuration).to_not be_nil
  end
end
