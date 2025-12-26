require_relative "stats/version"
require "open-uri"
require "json"

module Github
  module Release
    module Stats
      def self.downloads(repo)
        url = "https://api.github.com/repos/#{repo}/releases"
        releases = JSON.parse open(url).read

        prod_releases =  releases.select do |r|
          !r["draft"] && !r["prerelease"] && r["assets"] && !r["assets"].empty?
        end

        stats = prod_releases.map do |r|
          [r["tag_name"], r["assets"].first["download_count"], r]
        end

        stats
      end
    end
  end
end
