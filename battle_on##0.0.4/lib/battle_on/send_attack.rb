require 'JSON'

module BattleOn

  class SendAttack
    attr_reader :game_id, :args, :x, :y

    def self.execute(game_id, args)
      new(game_id, args).execute
    end

    def initialize(game_id, args)
      @game_id = game_id
      @x  = args[:x] or raise ArgumentError, "Must pass 'x' attack"
      @y  = args[:y] or raise ArgumentError, "Must pass 'y' attack"
    end

    def execute
      JSON.parse attack
    end

    private

    def attack
      RestClient.post "http://battle.platform45.com/nuke", attack_params
    end

    def attack_params
      { x: x, y: y, id: game_id}.to_json
    end

  end
end
