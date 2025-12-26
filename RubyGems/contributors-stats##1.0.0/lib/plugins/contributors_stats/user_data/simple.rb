module ContributorsStats::UserData

  # fill in user data using minimal possible set of data
  class Simple

    # fill in user data using minimal possible set of data
    def self.load(login, data, contributions)
      {
        'avatar_url'    => data['avatar_url'],
        'name'          => login,
        'url'           => data['url'],
        'html_url'      => profile_url(login),
        'contributions' => contributions
      }
    end
    # build github profile url for the given user name
    # @param username [String]
    # @return [String] github profile url
    def self.profile_url(username)
      "https://github.com/#{username}"
    end
  end
end
