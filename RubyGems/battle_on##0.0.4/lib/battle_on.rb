require "battle_on/version"
require "battle_on/register_game"
require "battle_on/send_attack"

module BattleOn

  def self.begin(name, email)
    RegisterGame.execute(name, email)
  end

  def self.attack(game_id, attack={})
    SendAttack.execute(game_id, attack)
  end

end
