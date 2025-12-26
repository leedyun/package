require 'spec_helper'
require 'benchmark'

describe ActiveRecord do
  before do
    20.times do
      Item.create(field_1:'boo', field_2:'boo', field_3:1)
      Item.create(field_1:'hoo', field_2:'hoo', field_3:2)
    end
  end
  context "sanity check" do
    specify { Item.count.should be == 40 }
  end
  describe ".lightning" do
    specify { Item.lightning.count.should be == 40 }
    specify { Item.lightning.first.should be == { "field_1" => 'boo', "field_2" => 'boo', "field_3" => 1 } }
    specify { Item.lightning.last.should be == { "field_1" => 'hoo', "field_2" => 'hoo', "field_3" => 2 } }
  end
  context "with an existing query" do
    subject { Item.where(field_1:'boo') }
    specify { subject.lightning.count.should be == 20 }
    specify { subject.lightning.first.should be == { "field_1" => 'boo', "field_2" => 'boo', "field_3" => 1 } }
    specify { subject.lightning.last.should be == { "field_1" => 'boo', "field_2" => 'boo', "field_3" => 1 } }
  end
  context "with specified fields" do
    subject { Item.lightning(:field_1) }
    specify { subject.first.should be == { 'field_1' => 'boo' } }
  end

  describe "performance" do
    let!(:active_record) do
      Benchmark.realtime{
        100.times do
          Item.all
        end
      }
    end
    let!(:lightning) do
      Benchmark.realtime{
        100.times do
          Item.lightning
        end
      }
    end
    specify { puts "active record = #{active_record}" } 
    specify { puts "lightning = #{lightning}" } 
    specify { active_record.should be > lightning }
  end
end
