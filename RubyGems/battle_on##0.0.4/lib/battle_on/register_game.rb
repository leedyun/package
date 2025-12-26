require 'json'
require 'rest_client'

module BattleOn

  class RegisterGame
    attr_reader :name, :email

    def self.execute(name, email)
      new(name, email).execute
    end

    def initialize(name, email)
      @name =  name  or raise ArgumentError, "Missing your name"
      @email = email or raise ArgumentError, "Missing your email"
    end

    def execute
      JSON.parse register
    end

    private

    def register
      RestClient.post "http://battle.platform45.com/register", {name: name, email: email}.to_json
    end

  end
end
