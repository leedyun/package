ActiveRecord::Schema.define do
  create_table :owners, :force => true
  create_table :pets, :force => true do |t|
    t.belongs_to :owner
  end
end
