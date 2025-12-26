# -*- encoding : utf-8 -*-
require 'cinch'

module Cinch
  module Plugins
    # CInch Plugin to search logs
    class LogSearch
      include Cinch::Plugin

      self.help = 'Use .search <text> to search the logs. *Only works via ' \
                  'private message*, limited to 5 results for now.'

      match(/search (.*)/, react_on: :private)

      def initialize(*args)
        super
        @max_results   = config[:max_results] || 5
        @log_directory = config[:logs_directory] ||
                         File.join('.', 'logs', '*.log')
      end

      def execute(m, search)
        return unless log_files_exist?

        matches = search_for(search)

        if matches.empty?
          m.user.msg 'No matches found!'
          return
        end

        msg = ['Found', matches.count, 'matches before giving up,',
               'here\'s the most recent', @max_results]

        m.user.msg msg.join(' ')
        matches.each { |match| m.user.msg match }
      end

      private

      def log_files_exist?
        return true if File.exist?(@log_directory)
        debug 'Log files not found!'
        false
      end

      def search_for(search_term)
        matches = []

        # Search the logs for the phrase, this is pretty simple and kind of
        #   dumb. I should probably make this smarter by using a real search
        #   algo at some point, if people care.
        Dir[@log_directory].sort.reverse.each do |file|
          matches += File.open(file, 'r').grep(Regexp.new(search_term))
          # For the sake of sanity, stop looking once we find @max_results
          break if matches.length > @max_results
        end

        # I hate new lines.
        matches.map(&:chomp).reverse[0..(@max_results - 1)].reverse
      end
    end
  end
end
