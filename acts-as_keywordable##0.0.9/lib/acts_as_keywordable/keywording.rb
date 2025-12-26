class Keywording < ActiveRecord::Base
  belongs_to :keyword
  belongs_to :keywordable, :polymorphic => true

  def self.tagged_class(keywordable)
    ActiveRecord::Base.send(:class_name_of_active_record_descendant, keywordable.class).to_s
  end

  def self.find_taggable(tagged_class, tagged_id)
    tagged_class.constantize.find(tagged_id)
  end
end