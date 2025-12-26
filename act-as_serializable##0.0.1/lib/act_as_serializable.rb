require "act_as_serializable/version"

module ActAsSerializable
  extend ActiveSupport::Concern

  module ClassMethods

    def act_as_serializable fields

      fields.each do |field|
        self.serialize field
        self.before_save :set_eval
      end


      define_method 'set_eval' do
        fields.each do |field|
          set_eval_when(field)
        end
      end

      define_method 'set_eval_when' do |field|
        if !self[field].blank? && self[field].class==String
          self[field] = eval self[field]
        elsif self[field].blank?
          self[field] = []
        else
          self[field]
        end
      end
    end

  end

  module InstanceMethods
  end

end

ActiveRecord::Base.send(:include, ActAsSerializable)