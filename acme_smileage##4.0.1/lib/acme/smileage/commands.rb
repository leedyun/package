require "acme/smileage/commands/oricon"
require "acme/smileage/commands/soundscan"

module Acme
  class Smileage
    module Commands
      class Main < Thor
        desc "oricon", "Show oricon data"
        subcommand "oricon", Acme::Smileage::Commands::Oricon

        desc "soundscan", "Show soundscan data"
        subcommand "soundscan", Acme::Smileage::Commands::SoundScan
      end
    end
  end
end
