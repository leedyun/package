#/usr/bin/env ruby

##
# static content update for speed and avoiding GH limits
# read GitHub contributions, transform to urls and update files
# all public methods return self for easy chaining
#
# Example:
#
#     ContributorsStats.load(org: 'railsisntaller').format.update('public/contributors.html')
#     contributors = ContributorsStats.load(repo: 'railsisntaller/website')
#     contributors.format(:html).update('public/index.html', 'public/contributors.html')
#     contributors.format(:markdown).save('public/contriutors.md')
#

require 'pluginator'
require 'contributors_stats/calculator'

# Calculate contribution statistics for projects,
# by default supports github organizations and repositories,
# but is easily extendible with plugins.
module ContributorsStats
  # Initialize ContributorsStats
  # @see ContributorsStats::Calculator.new
  def self.load(options = {})
    ContributorsStats::Calculator.new(options)
  end
end
