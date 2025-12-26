class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.references :project
      t.text :summary
      t.datetime :deadline_at

      t.timestamps
    end
    add_index :milestones, :project_id
  end
end
