require 'active_support'
require 'active_record'

module ActAsNameable::Base
  extend ActiveSupport::Concern

  module ClassMethods
    def act_as_nameable
      attr_accessible :first_name, :surname
    end
  end
end

ActiveRecord::Base.send :include, ActAsNameable::Base
