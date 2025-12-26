module AwsBlueGreenDeploy
  class DeployController
    def initialize(as_controller, lb_controller)
      @as_controller = as_controller
      @lb_controller = lb_controller 
    end

    def create_new_launch_config(name, image, instance_type, key_pair, security_groups, user_data)
      options = {:key_pair => key_pair, :security_groups => security_groups, :user_data => user_data}
      launch_config = @as_controller.launch_configurations.create(name, image, instance_type, options)
    end

    def out_rotation_groups(elb_name)
      target_groups = groups_associated_to_elb(elb_name)
      in_rotation_groups = in_rotation_groups(elb_name)
      out_rotation_groups = []
      target_groups.each do |target_group|
        in_rotation_groups.each do |ir_group|
          out_rotation_groups.push(target_group) unless target_group.name == ir_group.name
        end
      end

      out_rotation_groups.each{|group| puts group.name}
    end

    def in_rotation_groups(elb_name)
      target_groups = groups_associated_to_elb(elb_name)
      in_rotation_groups = []
      in_rotation_instances = @lb_controller.load_balancers[elb_name].instances.map{|instance| instance.id}
      target_groups.each do |group| 
        group_instances = group.ec2_instances.map{|instance| instance.id}
        if (in_rotation_instances & group_instances).count > 0
          in_rotation_groups.push(group)
        end
      end
      in_rotation_groups
    end

    def update_groups_lc_and_scale_up(autoscaling_groups, launch_config, asg_size)
      autoscaling_groups.each{|group| replace_launch_config(group, launch_config, asg_size)}
    end

    def rotate_groups(groups, elb_name)
      instance_ids = []
      groups.each do |group|
        group.ec2_instances.each{|instance| instance_ids.push(instance.instance_id)}
      end
      instance_ids.each{|instance_id| puts instance_id}
      instance_ids.each{|instance_id| @lb_controller.load_balancers[elb_name].instances.deregister(instance_id)}
    end

    private
    def replace_launch_config(group, launch_config, asg_size)
        group.update(desired_capacity: asg_size, min_size: asg_size, max_size: asg_size, launch_configuration: launch_config)
    end

    def groups_associated_to_elb(elb_name)
      @as_controller.groups.select{|group| group.load_balancer_names.include?(elb_name)}
    end
  end
end