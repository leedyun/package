module ActsAsExplorable::Element
  #
  # Generates a +where+ clause to look up the searched string in the given columns
  #
  class DynamicFilter < Base
    def after_init
      @query_type = :where
    end

    def render
      @query_parts << table[type].lower.in(@parameters)
      @full_query = @query_parts.first
    end
  end
end
