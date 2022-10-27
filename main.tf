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
  availability_zone = "us-east-1a"

  tags = {
    cretaed-by = "Shivangi"
  }
}

resource "aws_subnet" "test-subnet2" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"

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

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.test-subnet2.id
  route_table_id = aws_route_table.test-route.id
}
resource "aws_security_group" "test-securitygroup" {
  name        = "allow_tls1"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    description      = "80 from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    description      = "443 from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    description      = "3306 from mysql"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
   #cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.test-db-securitygroup.id]
  }


  ingress {
    description      = "icmp from anywhere"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_security_group" "test-securitygroup-elb" {
  name        = "allow_tls2"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
 egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
   # security_group_id = aws_security_group.test-securitygroup.id
    cidr_blocks     = ["0.0.0.0/0"]
    #destination_security_group_id = aws_security_group.test-securitygroup.id
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
#resource "aws_instance" "test-server" {
#  ami       = "ami-05fa00d4c63e32376"
#  instance_type = "t2.micro"
#  #subnet_id = [ aws_subnet.test-subnet.id, aws_subnet.test-subnet2.id ]
#  associate_public_ip_address = "true"
#  key_name = "aws-key"
#  security_group_ids = "aws_instance.vpc_security_group_ids"
 # tags = {
  #  type = "web-server"
  #}
#}
#resource "aws_network_interface_sg_attachment" "sg_attachment" {
  #security_group_id    = "${aws_security_group.test-securitygroup.id}"
  #network_interface_id = "${aws_launch_configuration.test-launchconfig.primary_network_interface_id}"
#}

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
  user_data       = file("/terraform/otherfiles/user-data.sh")
  security_groups = [aws_security_group.test-securitygroup.id]
  key_name = "aws-key"
  associate_public_ip_address = "true"
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
  vpc_zone_identifier       = [ aws_subnet.test-subnet.id, aws_subnet.test-subnet2.id ]
#  associate_public_ip_address = "true"

    target_group_arns = [
    aws_lb_target_group.test-targetgroups.arn
  ]  
}

resource "aws_lb" "test-elb" {
  name               = "test-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.test-securitygroup-elb.id]
  subnets            = [ aws_subnet.test-subnet.id, aws_subnet.test-subnet2.id ]
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
  lb_target_group_arn   = aws_lb_target_group.test-targetgroups.arn
}

#resource "aws_s3_bucket" "test-bucket" {
 # bucket = "manual-bucket1234"
#}

resource "aws_iam_policy" "test-s3-policy" {
  name        = "ec2-s3" 
  description = "My test policy"
  policy = file("/terraform/otherfiles/s3-policy")

}

resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role"
  assume_role_policy = file("/terraform/otherfiles/trust-policy-ec2")
}

resource "aws_iam_instance_profile" "test_profile" {                             
name  = "test_profile"                         
role = aws_iam_role.ec2_s3_access_role.name
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = [ aws_iam_role.ec2_s3_access_role.name ]
  policy_arn = aws_iam_policy.test-s3-policy.arn
}

resource "aws_s3_bucket" "manual-bucket1234" {
  bucket = "manual-bucket123412"

  tags = {
    Name        = "My bucket"
    Created-by = "shivangi"
  }
}
####  IAM role for code deploy ##################
resource "aws_iam_role" "code-deploy-trust" {
  name = "code-deploy-trust"

  assume_role_policy = file("/terraform/otherfiles/trust-policy-codedeploy")
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.code-deploy-trust.name
}

resource "aws_security_group" "test-db-securitygroup" {
  name        = "DB-SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.test-vpc.id
}

resource "aws_security_group_rule" "allow_3306" {

    type = "ingress"
    description      = "TLS from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
#    cidr_blocks     = ["0.0.0.0/0"]
    security_group_id    = aws_security_group.test-db-securitygroup.id
    source_security_group_id = aws_security_group.test-securitygroup.id
}

resource "aws_db_instance" "test-database" {
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = "${aws_db_subnet_group.db-subnet.name}"
  vpc_security_group_ids = ["${aws_security_group.test-db-securitygroup.id}"]
}

resource "aws_db_subnet_group" "db-subnet" {
 name = "db_subnet_group"
 subnet_ids = ["${aws_subnet.test-subnet.id}", "${aws_subnet.test-subnet2.id}"]
}



##################################################
