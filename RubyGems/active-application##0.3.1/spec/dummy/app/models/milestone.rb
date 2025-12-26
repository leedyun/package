class Milestone < ActiveRecord::Base
  belongs_to :project
  has_many :tasks

  attr_accessible :deadline_at, :summary
end
