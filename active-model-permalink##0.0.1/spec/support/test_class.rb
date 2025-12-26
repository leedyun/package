require 'active_model'

class TestClass  
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  
  include ActiveModel::Permalink
  
  attr_accessor :name
  attr_accessor :title
  attr_accessor :permalink
end
