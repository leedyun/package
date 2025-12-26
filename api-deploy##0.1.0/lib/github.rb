class GithubApi
  attr_reader :api

  ORG = 'YTech'


  def initialize
    @api = Github.new(
      basic_auth: "#{ENV['GITHUB_API_USER']}:#{ENV['GITHUB_API_PASS']}",
      org: ORG
    )
  end
end
