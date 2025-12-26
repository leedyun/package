require 'spec_helper'
require 'active_search'

class Model < ActiveRecord::Base
end

class SearchableModel < ActiveRecord::Base
  belongs_to :is_not_searchable_model
  belongs_to :is_searchable_model
  searchable_by :test, :banana
end

class IsNotSearchableModel < ActiveRecord::Base
  has_many :searchable_models
end

class IsSearchableModel < ActiveRecord::Base
  has_many :searchable_models
  searchable_by :test
end

class FindableModel < ActiveRecord::Base
  findable_by :test
end

describe ActiveSearch do
      before(:each) do
        @model = Model.create(test: "test")
        @is_not_searchable_model = IsNotSearchableModel.create(test: "test")
        @is_searchable_model = IsSearchableModel.create(test: "test")
        @bob = SearchableModel.create(test: "Bob",
                                      banana: "yellow",
                                      is_not_searchable_model_id: @is_not_searchable_model.id,
                                      is_searchable_model_id: @is_searchable_model.id)
        @bob2 = SearchableModel.create(test: "Bob",
                                       banana: "brown",
                                       is_not_searchable_model_id: @is_not_searchable_model.id,
                                       is_searchable_model_id: @is_searchable_model.id)
      end
  describe "Active Record Model" do
    context "#is_searchable?" do
      it "returns false by default" do
        expect(Model.is_searchable?).to be_false
      end

      it "returns true if '#search_by' is included" do
        expect(SearchableModel.is_searchable?).to be_true
      end
    end
    context "#searchable_values" do
      it "returns values passed to '#searchable_by'" do
        expect(SearchableModel.searchable_values).to include(:test)
      end
    end
    context "#find_by_values" do
        it "returns an array of matching objects" do
        expect(SearchableModel.find_by_value("Bob")).to include(@bob)
        expect(SearchableModel.find_by_value("Bob")).to include(@bob2)
        expect(SearchableModel.find_by_value("yellow")).to include(@bob)
        expect(SearchableModel.find_by_value("yellow")).to_not include(@bob2)
      end
    end
  end
  describe "Active Record Associations" do
    context "#find_by_values" do
      it "returns an instance of a model's associations found by value when the model is searchable" do
        expect(@is_searchable_model.class.is_searchable?).to be_true
        expect(@is_searchable_model.find_by_value("yellow", "searchable_models")).to include(@bob)
        expect(@is_searchable_model.find_by_value("yellow", "searchable_models")).to_not include(@bob2)
      end
      it "returns an instance of a model's associations found by value when the model is not searchable" do
        expect(@is_not_searchable_model.class.is_searchable?).to be_false
        expect(@is_not_searchable_model.find_by_value("yellow", "searchable_models")).to include(@bob)
        expect(@is_not_searchable_model.find_by_value("yellow", "searchable_models")).to_not include(@bob2)
      end
    end
  end
  describe "Partial Matches" do
    context "#find_by_value" do
      it "returns the models as long as the value partially matches the '#seachable_values' strings" do
        expect(SearchableModel.find_by_value("ow")).to include(@bob)
        expect(SearchableModel.find_by_value("ow")).to include(@bob2)
      end
      it "does not return the value if the partial strings do not match" do
        expect(SearchableModel.find_by_value("low")).to include(@bob)
        expect(SearchableModel.find_by_value("low")).to_not include(@bob2)
        expect(SearchableModel.find_by_value("row")).to include(@bob2)
        expect(SearchableModel.find_by_value("row")).to_not include(@bob)
      end
      it "returns the models regardless of case" do
        expect(SearchableModel.find_by_value("bob")).to include(@bob)
        expect(SearchableModel.find_by_value("bob")).to include(@bob2)
        expect(SearchableModel.find_by_value("Yellow")).to include(@bob)
        expect(SearchableModel.find_by_value("Brown")).to include(@bob2)
      end
    end
  end
  describe "Method Aliases" do
    context "#searchable?" do
      it "is an alias for #is_searchable?" do
	expect(SearchableModel.searchable?).to eq(SearchableModel.is_searchable?)
	expect(Model.searchable?).to eq(Model.is_searchable?)
      end
    end
    context "#search_for" do
      it "is an alias for #find_by_value" do
        expect(SearchableModel.search_for("Bob")).to eq(SearchableModel.find_by_value("Bob"))
        expect(@is_searchable_model.search_for("yellow", "searchable_models")).to eq(@is_searchable_model.find_by_value("yellow", "searchable_models"))
        expect(@is_not_searchable_model.search_for("yellow", "searchable_models")).to eq(@is_not_searchable_model.find_by_value("yellow", "searchable_models"))
      end
    end
    context "#findable_by" do
      it "is an alias for #searchable_by" do
      	expect(FindableModel.searchable?).to eq(true)
      end
    end
  end
end
