class TasksController < ActiveApplication::ResourceController
  polymorphic_belongs_to :milestone, :project
end
