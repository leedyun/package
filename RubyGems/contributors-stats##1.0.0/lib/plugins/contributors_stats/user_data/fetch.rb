require 'contributors_stats/json_helper'

module ContributorsStats::UserData

  # fetch user data from github
  class Fetch
    extend ContributorsStats::JsonHelper

    # fetch user data from github
    def self.load(login, data, contributions)
      user_data = load_json(data['url'])
      user_data['contributions'] = contributions
      user_data
    end
  end
end
