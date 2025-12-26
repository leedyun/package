require "alphabet/rocker/version"

module Alphabet
  module Rocker
    class Titlez
      def rock_title
        self.to_s.split(/([ !'@#$%^&*(){}~_-])/).map(&:capitalize).join
      end
    end
  end
end
