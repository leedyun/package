require 'spec_helper_base'
require 'helpers/register_game_spec_helper'

describe BattleOn::RegisterGame do

  include RegisterGameSpecHelper

  describe ".execute" do

    let( :name ) { "henry@thehthornton.com" }
    let( :email ) { "henry thornton" }
    let( :begin_battle ) { BattleOn::RegisterGame }

    context "returns a new game" do

      it "returns a hash" do
        #given
        stubbed_request
        #when
        new_battle = begin_battle.execute(name, email)
        #expect
        new_battle.should be_an_instance_of(Hash)
      end

      it "game contains a id" do
        #given
        stubbed_request
        #when
        new_battle = begin_battle.execute(name, email)
        #expect
        new_battle.should include("id")
      end

      it "game contains an 'x'" do
        #given
        stubbed_request
        #when
        new_battle = begin_battle.execute(name, email)
        #expect
        new_battle.should include("x")
      end

      it "game contains an 'y'" do
        #given
        stubbed_request
        #when
        new_battle = begin_battle.execute(name, email)
        #expect
        new_battle.should include("y")
      end

    end

    context "request is formatted incorrectly" do

      let(:name_only)  { "henry thornton" }

      context "email is missing" do

        it "raises an ArgumentError" do
          expect { begin_battle.execute(name_only, nil) }.to raise_error(ArgumentError, /Missing your email/)
        end

      end

      let(:email_only) { "henry@thethornton.com" }

      context "name is missing" do

        it "raises an ArgumentError" do
          expect { begin_battle.execute(nil, email_only) }.to raise_error(ArgumentError, /Missing your name/)
        end

      end
    end
  end
end
