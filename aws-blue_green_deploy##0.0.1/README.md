# AwsBlueGreenDeploy

## Summary

This gem automates a "Blue/Green" style of web server farm deployments, in which one set of servers is active, in load balancer rotation, while the other set is out of rotation. Out of rotation servers are deployed to, validated and then put into rotation. The the formerly active servers are pulled out. 

This gem automates this process with AutoScaling groups, and actually eliminates the need to have a pool of inactive servers. These servers are created at deploy time.

This gem assumes you have 2 static autoscaling groups asscociated to the load balancer the deploy will be run against. 
This gem manipulates the launch configuration and asg size of any auto scaling group that does not have instances in load balancer rotation in order to create new instances with a new version of code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws_blue_green_deploy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aws_blue_green_deploy

## Usage

https://travis-ci.org/jparten/aws_blue_green_deploy.svg?branch=master

To use:

This gem assumes you have 2 static autoscaling groups asscociated to the load balancer the deploy will be run against. 
This gem manipulates the launch configuration and asg size of any auto scaling group that does not have instances in load balancer rotation in order to create new instances with
a new version of code. s


Build a hash or a json config with the following parameters:

* "elb_name" - Name of ELB to be manipulated by deploy action, the automation will identify which associated ASG's need to be manipulated.
* "asg_size" - Number of instances to scale load balancer during deployment
* "lc_name" - Name of launch configuration to be created by deployment process
* "lc_image" - Ami ID to be used by new launch configuration
* "lc_instance_type" - Instance size to be used by new new launch config
* "lc_key_pair" - Authentication keypair to be used by new launch config
* "lc_security_groups" - Array of security groups to be used by new launch config
* "lc_user_data" - User data to be passed in to each instance created by the new launch config
* "region" - AWS region where operation should is begin performed
* "access_key_id" - Key with access to perform EC2 operations
* "secret_access_key" - Secret key with access to perform EC2 operations

Once the parameters above are in a json file, a A/B style release can be enacted by:

```ruby
AwsBlueGreenDeploy.configure_with("path to json config")
AwsBlueGreenDeploy.enact_deployment
```

Alternatively you can configure by passing in a hash with the values above, overriding any values passed in via json:

```ruby
options = {:elb_name => "Test"}
AwsBlueGreenDeploy.configure(options)
AwsBlueGreenDeploy.enact_deployment
```

The module methods drive the DeployController class. This class can be used independently of the module to better control timing/validation neccessary for a production release. 


## Contributing

1. Fork it ( https://github.com/jparten/aws_blue_green_deploy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
