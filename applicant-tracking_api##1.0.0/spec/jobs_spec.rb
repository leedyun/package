require 'spec_helper'

describe ApplicantTracking::Jobs do

	it "finds all jobs" do
		FakeWeb.register_uri(:get, "https://key:pass@example.company.com/remote/jobs.json", :body => File.open("./spec/json/all_jobs.json").read)
		jobs = ApplicantTracking::Jobs.all
		jobs.count.should == 5
		jobs[0].title.should == "Account Executive"
		jobs[1].id.should == 339
	end

	it "finds hidden jobs" do
		FakeWeb.register_uri(:get, "https://key:pass@example.company.com/remote/jobs/hidden.json", :body => File.open("./spec/json/hidden_jobs.json").read)
		jobs = ApplicantTracking::Jobs.hidden
		jobs.count.should == 2
		jobs[0].title.should == "Account Executive"
		jobs[1].id.should == 357
	end

	it "finds archived jobs" do
		FakeWeb.register_uri(:get, "https://key:pass@example.company.com/remote/jobs/archived.json", :body => File.open("./spec/json/archived_jobs.json").read)
		jobs = ApplicantTracking::Jobs.archived
		jobs.count.should == 1
		jobs[0].title.should == "Web Developer"
		jobs[0].id.should == 339
	end

	it "finds active jobs" do
		FakeWeb.register_uri(:get, "https://key:pass@example.company.com/remote/jobs/active.json", :body => File.open("./spec/json/active_jobs.json").read)
		jobs = ApplicantTracking::Jobs.active
		jobs.count.should == 4
	end

	it "finds applications for a job" do
		FakeWeb.register_uri(:get, "https://key:pass@example.company.com/remote/jobs/339.json", :body => File.open("./spec/json/job_339.json").read)
		job = ApplicantTracking::Jobs.find(339)
		job.title.should == "Web Developer"
		FakeWeb.register_uri(:get, "https://key:pass@example.company.com/remote/jobs/339/applications.json", :body => File.open("./spec/json/job_339_applications.json").read)
		applications = job.applications.all
		applications.count.should == 4
		applications[0].email.should == "15861@company.com"
	end

	it "handles an array result from find" do
		FakeWeb.register_uri(:get, "https://key:pass@example.company.com/remote/jobs/294.json", :body => File.open("./spec/json/single_job.json").read)
		job = ApplicantTracking::Jobs.find(294)
		job.title.should == "Account Executive"
	end

	it "Updates applications for a job" do
		FakeWeb.register_uri(:get, "https://key:pass@example.company.com/remote/jobs/339.json", :body => File.open("./spec/json/job_339.json").read)
		FakeWeb.register_uri(:get, "https://key:pass@example.company.com/remote/jobs/339/applications.json", :body => File.open("./spec/json/job_339_applications.json").read)
		FakeWeb.register_uri(:post, "https://key:pass@example.company.com/remote/jobs/339/applications/17133.json", :body => '{"success": true}')

		app = ApplicantTracking::Jobs.find(339).applications.first
		app.id.should == 17133
		app.first_name = "A Test"
		app.save
	end
end
