require 'spec_helper'

describe "DeployController" do
  before do
    @as_controller = AWS::AutoScaling.new(:stub_requests => true, :access_key_id => "faux_key", :secret_access_key => "faux_access_key")
    @lb_controller = AWS::ELB.new(:stub_requests => true, :access_key_id => "faux_key", :secret_access_key => "faux_access_key")
    @dc = AwsBlueGreenDeploy::DeployController.new(@as_controller, @lb_controller)
  end

  describe "#create_new_launch_config" do
    before do
      @lc_name = "test-launch-config"
      @lc_image = "ami-000000a0"
      @lc_instance_type = "m3.medium"
      @lc_key_pair = "test-key-pair"
      @lc_security_groups = ["sg-00a00000","sg-00b00000", "sg-00c00000"]
      @lc_user_data = "test-user-data"
      @lc = @dc.create_new_launch_config(@lc_name, @lc_image, @lc_instance_type, @lc_key_pair, @lc_security_groups, @lc_user_data)
    end

    it "return an aws launch config" do
      expect(@lc).to be_a AWS::AutoScaling::LaunchConfiguration
    end

    it "should make a launch config in aws with the name specified" do
      expect(@as_controller.launch_configurations["test-launch-config"].name).to eq(@lc_name)    
    end
  end
end