class AddPublishedTo<%= table_name.camelize %> < ActiveRecord::Migration

  def self.up
    add_column :<%= table_name %>, :published, :boolean, :default => false
  end

  def self.down
    remove_column :<%= table_name %>, :published
  end

end
