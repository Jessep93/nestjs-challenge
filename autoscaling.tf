#Launch Configuration
resource "aws_launch_template" "web_server_launch_template" {
  name          = "${local.name_prefix}-launch-template"
  image_id      = "ami-087ba53385eb3f5a7"
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = ["${aws_security_group.web_sg.id}"]
  }
}

#Auto Scaling group

resource "aws_autoscaling_group" "web_server_asg" {
  name                      = "${local.name_prefix}-asg"
  vpc_zone_identifier       = [aws_subnet.web.id, aws_subnet.web.id]
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  health_check_type         = "ELB"
  health_check_grace_period = var.health_check_grace_period
  target_group_arns         = ["${aws_lb_target_group.web_lb_target_group.arn}"]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  launch_template {
    id      = aws_launch_template.web_server_launch_template.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
}



# Auto Scaling Policy
#scaling up the asg
resource "aws_autoscaling_policy" "asg_scaling_up_policy" {
  name                   = "${local.name_prefix}-asg-scaling-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_server_asg.name
}

#Scaling down the asg
resource "aws_autoscaling_policy" "asg_scaling_down_policy" {
  name                   = "${local.name_prefix}-asg-scaling-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_server_asg.name
}



# Cloudwatch Metrics
#Scaling up the ASG
resource "aws_cloudwatch_metric_alarm" "asg_scale_up_alarm" {
  alarm_name          = "${local.name_prefix}-web-server-scale-up-alarm"
  alarm_description   = "Alarm to trigger when CPU utilization is higher than set threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "75"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web_server_asg.name}"
  }
  alarm_actions = [aws_autoscaling_policy.asg_scaling_up_policy.arn]

}

#Scaling down the ASG
resource "aws_cloudwatch_metric_alarm" "asg_scale_down_alarm" {
  alarm_name          = "${local.name_prefix}-web-server-scale-down-alarm"
  alarm_description   = "Alarm to trigger when CPU utilization is lower than set threshold"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web_server_asg.name}"
  }
  alarm_actions = [aws_autoscaling_policy.asg_scaling_down_policy.arn]

}
