class Keyword < ActiveRecord::Base
  has_many :keywordings

  def self.parse(list)
    keyword_names = []


    keyword_names = list.split(/[\r\n]/).uniq.reject {|c| c == ""}

    # strip whitespace from the names
    keyword_names = keyword_names.map { |t| t.strip }

    # delete any blank tag names
    keyword_names = keyword_names.delete_if { |t| t.empty? }

    return keyword_names
  end

  def tagged
    @tagged ||= keywordings.collect { |keywording| keywording.keywordable }
  end

  def on(keywordable)
    keywordings.create :keywordable => keywordable
  end

  def also_on(keywordable)
    keywordings.find_all_by_keywordable_type(keywordable.to_s)
  end

  def ==(comparison_object)
    super || name == comparison_object.to_s
  end

  def to_s
    name
  end
end