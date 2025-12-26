class CreateModel < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.string :status
    end
  end
end
