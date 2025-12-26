# -*- encoding: utf-8 -*-

module Acme
  class Smileage
    class Discography
      class HelloProjectMusicAward
        attr_reader :year, :rank, :points, :votes

        def initialize(year, rank, points, votes)
          @year = year
          @rank = rank
          @points = points
          @votes = votes
        end

        def to_a
          [self.year, self.rank, self.points, self.votes]
        end
      end
    end
  end
end
