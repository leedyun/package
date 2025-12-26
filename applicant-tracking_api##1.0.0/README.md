### Applicant Tracking API gem

### Installation
This is a rubygem based on ActiveResource, and designed for Ruby 1.9.3 and greater. Install with this command:

``` bash
$ gem install applicant_tracking_api
```

### Configuration

For ruby projects, require the gem:

``` ruby
require 'applicant_tracking_api'
```

In rails, you can include in your Gemfile:

``` ruby
gem 'applicant_tracking_api'
```

Once you've obtained an api_key and password, you can set up the gem as follows:

``` ruby
ApplicantTracking.configure do |h|
  h.api_key = "key"
  h.api_password = "pass"
  h.domain = "subdomain.domain.com" # e.g., subdomain.domain.com
end
```

If you're using Rails, this should go in a new file called RAILS_ROOT/config/initializers/applicant_tracking.rb.

### Usage

``` ruby
# get all your jobs
myjobs = ApplicantTracking::Jobs.all

# get a specific job
myjob = ApplicantTracking::Jobs.find(111)

# get active jobs
myjobs = ApplicantTracking::Jobs.active

# get hidden jobs
myjobs = ApplicantTracking::Jobs.hidden

# get archived jobs
myjobs = ApplicantTracking::Jobs.archived

# access applications on a specific job
myjob = ApplicantTracking::Jobs.find(111)
myjob.applications.all

# get all applications with no rating for this job
myjob.applications.unrated

# get all applications with a rating for this job
myjob.applications.rated

# get all archived applications for this job
myjob.applications.archived

# get a specific application 
myjob = ApplicantTracking::Applications.find(111)

# get all applications
myapplications = ApplicantTracking::Applications.all

# get all applications with a rating
myapplications = ApplicantTracking::Applications.rated

# get all applications with no rating
myapplications = ApplicantTracking::Applications.unrated

# get all archived applications 
myapplications = ApplicantTracking::Applications.archived
```

Application objects have the following attributes:

``` ruby
# Application objects

	myapplication.id # app id
	myapplication.job # job title
	myapplication.job_id 
	myapplication.status 
	myapplication.first_name 
	myapplication.last_name 
	myapplication.phone 
	myapplication.email 
	myapplication.rating 
	myapplication.applied_at 
	myapplication.source # where the applicant came from 
	myapplication.archived # 1 for archived, 0 for active
```

Job objects have these attributes:

``` ruby
# Job objects

	myjob.id # job id
	myjob.company # company name
	myjob.job_code 
	myjob.title 
	myjob.abstract 
	myjob.description 
	myjob.city 
	myjob.state 
	myjob.country 
	myjob.archived # 1 for archived, 0 for active
	myjob.url # short url
	myjob.created_at 
```

