# coding: utf-8
module AlphabeticalPaginate
  class Language
    attr_reader :code

    def initialize(code)
      @code = code
    end

    def russian?
      defined?(I18n) && I18n.locale == :uk && code == :uk
    end

    def letters_regexp
      russian? ? /[а-їА-ї]/ : /[a-zA-Z]/
    end

    def default_letter
      russian? ? "а" : "a" # First 'a' is russian, second - english
    end

    # used in view_helper
    def letters_range
      if russian?
        ('А'..'ї').to_a
      else
        ('A'..'Z').to_a
      end
    end

    # used in view_helper
    def output_letter(l)
      (l == "All") ? all_field : l
    end

    # used in view_helper
    def all_field
      russian? ? 'Усі' : "All"
    end
  end
end
