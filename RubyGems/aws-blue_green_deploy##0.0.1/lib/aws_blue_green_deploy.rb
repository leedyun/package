require "aws_blue_green_deploy/version"
require "aws_blue_green_deploy/deploy_controller"
require 'json'
require 'aws-sdk'

module AwsBlueGreenDeploy
  # Configure through hash
  @config = {}

  def self.configure(opts = {})
    opts.each {|k,v| @config[k.to_sym] = v}
  end

  # Configure through yaml file
  def self.configure_with(path_to_json_file)
    begin
      config = JSON.parse(IO.read(path_to_json_file), {:symbolize_names => true})
    rescue Errno::ENOENT
      log(:warning, "JSON configuration file couldn't be found. Using defaults."); return
    end

    configure(config)
    "Loaded Config Successfully"
  end

  def self.config
    @config
  end

  def self.enact_deployment
    auth_options = {:access_key_id => config[:access_key_id], :secret_access_key => config[:secret_access_key], :session_token => config[:session_token], :region => config[:region]}
    as_controller = AWS::AutoScaling.new(auth_options)
    lb_controller = AWS::ELB.new(auth_options)
    dc = DeployController.new(as_controller, lb_controller)

    elb_name = config[:elb_name]
    asg_size = config[:asg_size].to_i
    lc_name = config[:lc_name]
    lc_image = config[:lc_image]
    lc_instance_type = config[:lc_instance_type]
    lc_key_pair = config[:lc_key_pair]
    lc_security_groups = config[:lc_security_groups]
    lc_user_data = config[:lc_user_data]

    lc = dc.create_new_launch_config(lc_name, lc_image, lc_instance_type, lc_key_pair, lc_security_groups, lc_user_data)
    puts "Created Launch Config: #{lc.name}"
    oor_groups = dc.out_rotation_groups(elb_name)
    puts "Out of rotation ASG: #{oor_groups.each{|group| group.name + " "}}"
    ir_groups = dc.in_rotation_groups(elb_name)
    puts "In rotation ASG: #{ir_groups.each{|group| group.name + " "}}"
    dc.update_groups_lc_and_scale_up(oor_groups, lc, asg_size)
    puts "Scaled up #{oor_groups.each{|group| group.name + " "}} to #{asg_size} instances with new launch config}"
    dc.rotate_groups(ir_groups, elb_name)
    puts "Removed #{ir_groups.each{|group| group.name + " "}}  instances from load balancer."
  end
end