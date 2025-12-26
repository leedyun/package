class Project < ActiveRecord::Base
  belongs_to :user
  has_many :milestones
  has_many :tasks, through: :milestones

  attr_accessible :name, :summary
  validates_presence_of :name, :summary
end
