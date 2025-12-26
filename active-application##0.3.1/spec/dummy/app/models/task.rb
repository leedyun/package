class Task < ActiveRecord::Base
  belongs_to :milestone
  attr_accessible :completed_at, :summary, :title
end
