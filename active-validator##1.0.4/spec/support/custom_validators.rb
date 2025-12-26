module ActiveValidator
  class MySubClass < ActiveValidator::Base

    validates :foo, presence: true

    safe_params :foo, :bar
  end
end
