require 'spec_helper_base'

describe BattleOn do

  describe ".begin" do

    it "delegates to RegisterGame" do
      #expect
      BattleOn::RegisterGame.should_receive(:execute).with("foo bar", "foo@bar.com")
      #when
      BattleOn.begin("foo bar", "foo@bar.com")
    end
  end

  describe ".attack" do

    it "delegates to SendAttack" do
      #expect
      BattleOn::SendAttack.should_receive(:execute).with(101, {:x_axis => 3, :y_axis => 2})
      #when
      BattleOn.attack(101, {:x_axis => 3, :y_axis => 2})
    end
  end

end
