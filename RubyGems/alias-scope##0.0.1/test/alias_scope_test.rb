require 'test_helper'

def setup_db()
  ActiveRecord::Base.logger
  ActiveRecord::Schema.define(version: 1) do
    create_table :fabrics do |t|
      t.column :name, :string
      t.column :flammable, :boolean
    end
  end

  Fabric.reset_column_information
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Fabric < ActiveRecord::Base
    scope :flammable, -> { where(flammable: true) }
    alias_scope :inflammable, :flammable
end

class FabricTest < MiniTest::Unit::TestCase

  def setup
    setup_db

    @cotton             = Fabric.create(name: 'Cotton',     flammable: true)
    @silk               = Fabric.create(name: 'Silk',       flammable: true)
    @wool               = Fabric.create(name: 'Wool',       flammable: false)
    @chain_mail         = Fabric.create(name: 'Chain Mail', flammable: false)
  end

  def teardown
    teardown_db
  end

  def test_scopes
    assert_includes Fabric.flammable, @cotton
    assert_includes Fabric.inflammable, @silk
    assert_equal Fabric.inflammable.count, 2
    assert_equal Fabric.flammable, Fabric.inflammable
  end
end
