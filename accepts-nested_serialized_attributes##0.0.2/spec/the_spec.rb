require 'spec_helper'
require 'active_record'
ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
ActiveRecord::Migrator.up 'db/migrate'
require 'accepts_nested_serialized_attributes'

class Association < ActiveRecord::Base
  belongs_to :model
end

describe AcceptsNestedSerializedAttributes do
  before :each do # Allow clean redefinition of Model
    Object.send :remove_const, :Model rescue nil
  end

  it 'renames nested attributes' do
    class Model < ActiveRecord::Base
      has_many :associations
      accepts_nested_attributes_for :associations
    end
    
    model = Model.new
    model.associations << Association.new

    expect(model.as_json(include: :associations)).to eq({
      id: nil, status: nil, associations_attributes: [{ id: nil, model_id: nil, status: nil }]
    })
  end

  it "doesn't rename an attribute if it is not declared as nested" do
    class Model < ActiveRecord::Base
      has_many :associations
    end

    model = Model.new
    model.associations << Association.new

    expect(model.as_json(include: :associations)).to eq({
      id: nil, status: nil, associations: [{ id: nil, model_id: nil, status: nil }]
    })
  end

  it 'symbolizes keys in serialized hash' do
    class Model < ActiveRecord::Base
      has_many :associations
      accepts_nested_attributes_for :associations
    end

    model = Model.new
    model.associations << Association.new

    all_symbols = model.as_json(include: :associations).keys.all? { |k| k.is_a? Symbol }
    expect(all_symbols).to be true
  end
end
