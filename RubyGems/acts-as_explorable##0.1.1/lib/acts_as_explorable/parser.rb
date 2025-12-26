module ActsAsExplorable
  ##
  # Transforms query strings to a Hash that can be used by ActsAsExplorable.
  #
  # @example
  #   ActsAsExplorable::Parser.transform('Zlatan in:first_name')
  #   => { values: ["Zlatan"], params: { in: ["first_name"] } }
  class Parser
    attr_reader :values, :params, :props

    #
    # Returns a transformed query Hash using the given query string
    # @param query_string [String] A query string
    # @param keys [Array] An Array of transformation rules
    #
    # @return [Hash] Transformed query
    def self.transform(query_string, *keys)
      instance = new(query_string)
      instance.parse(*keys)
    end

    def initialize(query_string)
      @query_string = query_string
      split_query_string
    end

    #
    # Parses the query string
    # @param keys [Hash] An Array of transformation rules
    #
    # @return [Hash] Transformed query
    def parse(*keys)
      split_query_string

      @props.each do |p|
        key, params = p.split(':').first.to_sym, p.split(':').last.split(',')
        next if !keys.flatten.include?(key) && !keys.empty?
        @params[key] ||= []
        @params[key] = @params[key] | params.map(&:downcase)
      end

      { values: @values, params: @params }
    end

    private

    def split_query_string
      @values = []
      @params = {}
      @props  = []

      @query_string.split(/\s+/).each do |q|
        if q =~ /\w+:[\w,-]+/
          @props << q
        else
          @values << q
        end
      end
    end
  end
end
