class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :milestone
      t.string :title
      t.text :summary
      t.datetime :completed_at

      t.timestamps
    end
    add_index :tasks, :milestone_id
  end
end
