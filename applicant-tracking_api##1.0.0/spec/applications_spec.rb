require 'spec_helper'

describe ApplicantTracking::Jobs do

	it "finds all applications" do
		FakeWeb.register_uri(:get, "https://key:pass@example.company.com/remote/applications.json", :body => File.open("./spec/json/applications.json").read)
		apps = ApplicantTracking::Applications.all
		apps.count.should == 28
		apps[0].email.should == "14275@company.com"
		apps[0].job_id.should == 294
	end

	it "finds archived applications" do
		FakeWeb.register_uri(:get, "https://key:pass@example.company.com/remote/applications/archived.json", :body => File.open("./spec/json/archived.json").read)	
		apps = ApplicantTracking::Applications.archived
		apps.count.should == 10
		apps[0].email.should == "14291@company.com"
		apps[0].job_id.should == 294
	end

	it "finds rated applications" do
		FakeWeb.register_uri(:get, "https://key:pass@example.company.com/remote/applications/rated.json", :body => File.open("./spec/json/rated.json").read)
		apps = ApplicantTracking::Applications.rated
		apps.count.should == 3
		apps[0].email.should == "14336@company.com"
		apps[0].job_id.should == 294
	end

	it "finds unrated applications" do
		FakeWeb.register_uri(:get, "https://key:pass@example.company.com/remote/applications/unrated.json", :body => File.open("./spec/json/unrated.json").read)
		apps = ApplicantTracking::Applications.unrated
		apps.count.should == 15
		apps[0].email.should == "14275@company.com"
		apps[0].job_id.should == 294
	end


end
