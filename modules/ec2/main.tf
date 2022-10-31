resource "aws_launch_configuration" "test-launchconfig" {
  name_prefix     = "learn-terraform-aws-asg-"
  image_id        = var.ami_id
  instance_type   = "t2.micro"
  user_data       = file("/terraform/otherfiles/user-data.sh")
  security_groups = [aws_security_group.test-securitygroup.id]
  key_name = "aws-key"
  associate_public_ip_address = "true"
 #tags  = {
 # Key = "name"
 # Value = "app_server"
 #}	
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "test-asggroup" {
  name                      = "test-autoscaling-group"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  #placement_group           = aws_placement_group.test.id
  launch_configuration      = aws_launch_configuration.test-launchconfig.name
  tag {
     key = "name"
     value = "app_server"
     propagate_at_launch = true
  }
  vpc_zone_identifier       = [ aws_subnet.test-subnet.id, aws_subnet.test-subnet2.id ]
#  associate_public_ip_address = "true"

  target_group_arns = [
    aws_lb_target_group.test-targetgroups.arn
  ]  
}

resource "aws_autoscaling_attachment" "test-autosacling-attachment" {
  autoscaling_group_name = aws_autoscaling_group.test-asggroup.id
  lb_target_group_arn   = aws_lb_target_group.test-targetgroups.arn
}

resource "aws_key_pair" "test-keypair" {
  key_name   = "aws-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYNJjRNZzpAzYnCc6eSnEkfLIU10iTf4SMiGjbYq3WYCxCEAjwBD8IQRGxqz3FMQ4kud8zdE6bOOSCIWjXzELUGcAAxSudf0fUvjVHBFHwvr+jjnPbda7oxpTyRJHKg1DVzN8drsa+DB3IskMxBIJtWtPlpalaGhe1w4vLwqrTPXb3zsAPqdwxC2F7KHWUuWm+UtolFvOLVVy1+1mfGdPsFgH2cCIRuay9Xf6O2h3PLt6e5vT7iNWNrDlMLnXRwNnFW/V1P74MzUO9eqDnk9Gztz2r5RHF0iBwIUY9c3FZikEV9h8bRjgL/mo4/VBg1Fg2mUsQHbTuZb5rgU/fQAOH root@86ed3e3c5b1c.mylabserver.com"
}
