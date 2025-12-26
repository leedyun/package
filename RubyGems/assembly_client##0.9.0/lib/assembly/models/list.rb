module Assembly
  class List < Model
    def each(&blk)
      self.data.each(&blk)
    end

    def next
      self
    end

    def next_page
      @values[:next_page]
    end

    def prev_page
      @values[:prev_page]
    end

    def current_page
      @values[:current_page] || 1
    end

    def total_pages
      @values[:total_pages] || 1
    end

    def total_count
      @values[:total_count] || 0
    end
  end
end