module TestHelper
  private

  class Book
    attr_accessor :authors
    attr_reader   :errors

    def initialize
      @authors = []
      @errors  = []
      @errors.define_singleton_method(:add) { |attribute, message| self << { attribute: attribute, message: message } }
    end

    def read_attribute_for_validation(attribute)
      self.send(attribute.to_sym)
    end
  end

  class Author
    attr_accessor :books

    def initialize
      @books   = []
    end

    def marked_for_destruction?
      @marked_for_desctruction || false
    end

    def mark_for_destruction
      @marked_for_desctruction = true
    end
  end

  def book_with_omitted_authors; Book.new              ; end

  def orphaned_book            ; book                  ; end

  def book_with_an_author(marked_for_destruction = false)
    book_by [author(marked_for_destruction)]
  end

  def book_with_some_authors(config = [false] * 5)
    book(config.map { |item| author item })
  end

  private

  def book(authors = [])
    Book.new.tap do |book|
      book.authors.concat authors
    end
  end

  alias_method :book_by, :book

  def author(marked = false)
    Author.new.tap do |author|
      author.mark_for_destruction if marked
    end
  end
end

