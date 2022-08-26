terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  shared_config_files      = ["/root/.aws/config"]
  shared_credentials_files = ["/root/.aws/credentials"]
}
# Create a VPC
resource "aws_vpc" "test-vpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "test-subnet" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    cretaed-by = "Shivangi"
  }
}
resource "aws_internet_gateway" "test-gateway" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    created-by = "shivangi"
  }
}
#resource "aws_internet_gateway_attachment" "ig-attachment" {
#  internet_gateway_id = aws_internet_gateway.test-gateway.id
#  vpc_id              = aws_vpc.test-vpc.id
#}
resource "aws_route_table" "test-route" {
  vpc_id = aws_vpc.test-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-gateway.id
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.test-subnet.id
  route_table_id = aws_route_table.test-route.id
}
resource "aws_security_group" "test-securitygroup" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "test-securitygroup-elb" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#resource "aws_security_group_rule" "test-rule" {
#  type              = "ingress"
#  from_port         = 0
#  to_port           = 22
#  protocol          = "tcp"
#  cidr_blocks       = [aws_vpc.test-vpc.cidr_block]
#  security_group_id = "aws_instance.vpc_security_group_ids"
#}
resource "aws_instance" "test-server" {
  ami       = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.test-subnet.id
  associate_public_ip_address = "true"
  key_name = "aws-key"
#  security_group_ids = "aws_instance.vpc_security_group_ids"
  tags = {
    type = "web-server"
  }
}
resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = "${aws_security_group.test-securitygroup.id}"
  network_interface_id = "${aws_instance.test-server.primary_network_interface_id}"
}

resource "aws_key_pair" "test-keypair" {
  key_name   = "aws-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYNJjRNZzpAzYnCc6eSnEkfLIU10iTf4SMiGjbYq3WYCxCEAjwBD8IQRGxqz3FMQ4kud8zdE6bOOSCIWjXzELUGcAAxSudf0fUvjVHBFHwvr+jjnPbda7oxpTyRJHKg1DVzN8drsa+DB3IskMxBIJtWtPlpalaGhe1w4vLwqrTPXb3zsAPqdwxC2F7KHWUuWm+UtolFvOLVVy1+1mfGdPsFgH2cCIRuay9Xf6O2h3PLt6e5vT7iNWNrDlMLnXRwNnFW/V1P74MzUO9eqDnk9Gztz2r5RHF0iBwIUY9c3FZikEV9h8bRjgL/mo4/VBg1Fg2mUsQHbTuZb5rgU/fQAOH root@86ed3e3c5b1c.mylabserver.com"
}

resource "aws_lb_target_group" "test-targetgroups" {
  name     = "test-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.test-vpc.id
}

resource "aws_launch_configuration" "test-launchconfig" {
  name_prefix     = "learn-terraform-aws-asg-"
  image_id        = "ami-05fa00d4c63e32376"
  instance_type   = "t2.micro"
  user_data       = file("/tmp/user-data.sh")
  security_groups = [aws_security_group.test-securitygroup.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "test-asggroup" {
  name                      = "test-autoscaling-group"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = true
  #placement_group           = aws_placement_group.test.id
  launch_configuration      = aws_launch_configuration.test-launchconfig.name
  vpc_zone_identifier       = [aws_subnet.test-subnet.id]
  
}

resource "aws_lb" "test-elb" {
  name               = "test-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.test-securitygroup-elb.id]
  subnets            = aws_subnet.test-subnet.ids
}

resource "aws_lb_listener" "test-elb-listener" {
  load_balancer_arn = aws_lb.test-elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test-targetgroups.arn
  }
}

resource "aws_autoscaling_attachment" "test-autosacling-attachment" {
  autoscaling_group_name = aws_autoscaling_group.test-asggroup.id
  alb_target_group_arn   = aws_lb_target_group.test-tg.arn
}
