module ActsAsExplorable::Element
  #
  # Generates an +order+ query part to sort by the given columns
  #
  class Sort < Base
    def after_init
      @query_type = :reorder
    end

    def render
      @full_query = @parameters.map do |f|
        if f =~ /(-asc|-desc)/
          { f.split('-').first.to_sym => f.split('-').last.to_sym }
        else
          { f.to_sym => :desc }
        end
      end
    end
  end
end
