require_relative '../spec_helper'
require_relative '../../lib/it_tools/deploy'

describe Deployment::Maven do
  before :each do
    @maven = Deployment::Maven.new
  end
  describe "#new" do
    it "returns a new Maven object" do
      @maven.should be_an_instance_of Deployment::Maven
    end
  end

  describe "#get_artifact_type" do
    it "should return a type of assembled jar" do
      # @maven.
    end
  end
    
end
