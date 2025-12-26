class CreateAssociation < ActiveRecord::Migration
  def change
    create_table :associations do |t|
      t.references :model
      t.string :status
    end
  end
end
