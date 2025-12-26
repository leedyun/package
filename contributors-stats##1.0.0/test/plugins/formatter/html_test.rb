require 'test_helper'
require 'plugins/contributors_stats/formatter/html'

describe ContributorsStats::Formatter::Html do
  before do
    @user1_data = {
      'avatar_url'    => 'avatar_url1',
      'name'          => 'name1',
      'url'           => 'url1',
      'html_url'      => 'html_url1',
      'contributions' => 'contributions1',
    }
  end

  it "formats output - default template" do
    expected = %Q{<a href="html_url1" title="user1 - contributions1"><img src="avatar_url1" alt="user1 - contributions1"/></a>}
    html = ContributorsStats::Formatter::Html.new
    html.format("user1", @user1_data).must_equal(expected)
  end

  it "formats output - custom template" do
    login = "user1"
    template = %q{%Q{<span>login: #{login}, avatar_url: #{data['avatar_url']}, name: #{data['name']}, url: #{data['url']}, html_url: #{data['html_url']}, contributors: #{data['contributors']}</spam>}}
    expected = %Q{<span>login: #{login}, avatar_url: #{@user1_data['avatar_url']}, name: #{@user1_data['name']}, url: #{@user1_data['url']}, html_url: #{@user1_data['html_url']}, contributors: #{@user1_data['contributors']}</spam>}
    html = ContributorsStats::Formatter::Html.new(template: template)
    html.format(login, @user1_data).must_equal(expected)
  end
end
