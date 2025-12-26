module ActsAsExplorable::Element
  #
  # Generates a +where+ clause to look up the searched string in the given columns
  #
  class In < Base
    def after_init
      @query_type = :where
    end

    def render
      @parameters.each do |f|
        @query_parts <<
          table[f.to_sym].matches_any(@query_string.map { |q| "%#{q}%" })
      end
      @full_query = @query_parts.inject(:or)
    end
  end
end
