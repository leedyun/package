require 'contributors_stats/json_helper'

class ContributorsStats::Reader

  # Plugin to load contributions from Github organization
  class GhOrg
    extend ContributorsStats::JsonHelper

    # load contributions for Github organization
    # param name [String] name of the organization to load
    # return [Array] loaded conributors data
    def self.load(name)
      load_json(url_builder("orgs/#{name}/repos")).map{ |repo|
        data = load_json(repo['contributors_url'])
        yield(data, "#{name}/#{repo['name']}") if block_given?
        data
      }.inject(&:+)
    end

  end
end
