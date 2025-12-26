require 'contributors_stats/json_helper'

class ContributorsStats::Reader

  # Plugin to load contributions from Github repository
  class GhRepo
    extend ContributorsStats::JsonHelper

    # load contributions for Github repository
    # param name [String] name of the repository to load
    # return [Array] loaded conributors data
    def self.load(name)
      data = load_json(url_builder("repos/#{name}/contributors"))
      yield(data, name) if block_given?
      data
    end

  end
end
