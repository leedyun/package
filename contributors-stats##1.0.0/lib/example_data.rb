require 'contributors_stats/json_helper'

# Dump some test data from github, rather one time, but who knows ;)
class ExampleData
  include ContributorsStats::JsonHelper

  # setup proper context for dumping data
  def initialize(target_path = "../../test/fixtures-gh")
    target_path = File.expand_path( target_path, __FILE__ ) unless Dir.exist?(target_path)
    Dir.chdir(target_path)
    `rm -rf *` # clean
  end

  # parse organization data from given url, parses also repositories
  # @see .parse_repo
  def parse_org(org_url)
    puts "reading: #{org_url}"
    org_data = load_json(org_url)
    write(org_url, org_data)
    org_data.each do |repo|
      parse_repo(repo['contributors_url'], "  ")
    end
  end

  # parse repository data from given url, parses also users
  # @see .parse_repo
  def parse_repo(contributors_url, str_prefix="")
    puts "#{str_prefix}reading: #{contributors_url}"
    contributors_data = load_json(contributors_url)
    write(contributors_url, contributors_data)
    contributors_data.each do |contributor|
      parse_user(contributor['url'], str_prefix+"  ")
    end
  end

  # parse user data from given url
  def parse_user(user_url, str_prefix="")
    puts "#{str_prefix}reading: #{user_url}"
    user_data = load_json(user_url)
    write(user_url, user_data)
  end

  # saves content to path corresponding to the given file url
  def write(file, content)
    file = remove_prefix(file)
    return if File.exist?(file)
    `mkdir -p #{File.dirname(file)}`
    File.open(file, "w+") { |f|
      f.write(remove_prefix(JSON.pretty_generate(content)))
    }
  end

  # remove prefix from all urls in the given content
  def remove_prefix(conten)
    conten.gsub(/#{path_prefix}([^"]*)/, "\\1.json")
  end

end
