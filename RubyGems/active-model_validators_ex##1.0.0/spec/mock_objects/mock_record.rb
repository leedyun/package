require 'mongoid'

class MockRecord
  include Mongoid::Document

  field :array
  field :time
end