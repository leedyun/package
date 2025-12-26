require 'contributors_stats/reader'
require 'contributors_stats/formatter'

module ContributorsStats

  # Placeholder for user details resolution plugins
  module UserData
  end

  # Calculates statistics gathered from multiple sources
  class Calculator < Reader
    attr_accessor :user_data_type

    def initialize(options = {})
      @user_data_type = options.delete(:user_data) if options[:user_data]
      super(options)
    end

    # transform calculated data into asked format
    # @param type [String] name of plugin to use for formatting
    # @param options [Hash] list of options for the plugin to use
    # @return [ContributorsStats::Formatter]
    def format(type = :html, options = {})
      ContributorsStats::Formatter.new(calculated_data, type, options)
    end

  private

    # group data, calculate contributions, sort by contributions
    def calculated_data
      @data ||= @raw_data.group_by { |contributor|
        contributor['login']
      }.map {|login, data|
        log "user: #{login}"
        [login, user_data(login, data)]
      }.sort_by{|login, data|
        [1000000/data['contributions'], login]
      }
    end

    def contributions(data)
      data.map{|repo| repo['contributions'].to_i}.inject(&:+)
    end

    def user_data(login, data)
      @user_data_plugin ||= plugins.first_class!("user_data", user_data_type || :simple)
      @user_data_plugin.load(login, data.first, contributions(data))
    end
  end
end
