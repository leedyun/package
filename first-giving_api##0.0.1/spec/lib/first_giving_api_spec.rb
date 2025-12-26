require 'spec_helper'
require 'pry'

describe FirstGivingApi do
  context "configuration" do
    describe ".app_key" do
      it "should return default key" do
        FirstGivingApi.api_key.should eql(FirstGivingApi::Configuration::DEFAULT_API_KEY)
      end
    end
    describe ".format" do
      it "should return default format" do
        FirstGivingApi.format.should eql(FirstGivingApi::Configuration::DEFAULT_FORMAT)
      end
    end
    describe ".user_agent" do
      it "should return default user agent" do
        FirstGivingApi.user_agent.should eql(FirstGivingApi::Configuration::DEFAULT_USER_AGENT)
      end
    end
    describe ".method" do
      it "should return default http method" do
        FirstGivingApi.method.should eql(FirstGivingApi::Configuration::DEFAULT_METHOD)
      end
    end
  end
  context "charity" do
    describe "query_contains" do
      it "should return data for charities containing marijuana" do
        org_data = FirstGivingApi.lookup("MARIJUANA")
        org_data.should_not be_nil
        org_data.each do |org|
          org[0]["organization_name"].should include("MARIJUANA")
        end
      end
    end
    describe "query_starts_with" do
      it "should return data for charities starting with marijuana" do
        org_data = FirstGivingApi.lookup_starting_with("MARIJUANA")
        org_data.should_not be_nil
        org_data.each do |org|
          org[0]["organization_name"].should start_with("MARIJUANA")
        end
      end
    end
    describe "query_with_id" do
      it "should return data for the charity with UUID 0f0e0f80-2024-11e0-a279-4061860da51d" do
        org_data = FirstGivingApi.lookup_id("0f0e0f80-2024-11e0-a279-4061860da51d")
        org_data.should_not be_nil
        org_data["organization_uuid"].should eql("0f0e0f80-2024-11e0-a279-4061860da51d")
        org_data.keys.should eql(["organization_uuid", "organization_type_id", "organization_name", "government_id", "parent_organization_uuid", "address_line_1", "address_line_2", "address_line_3", "address_line_full", "city", "region", "postal_code", "county", "country", "address_full", "phone_number", "area_code", "url", "category_code", "latitude", "longitude", "revoked"])
      end
    end
  end
end
