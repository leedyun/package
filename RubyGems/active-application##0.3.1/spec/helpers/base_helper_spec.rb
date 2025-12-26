require "spec_helper"

describe ActiveApplication::BaseHelper do
  describe "#application_name" do
    it "returns application name" do
      helper.application_name.should eq("Active Application")
    end
  end
end
