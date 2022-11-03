
resource "aws_security_group" "test-db-securitygroup" {
  name        = "DB-SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.networking.vpc-id
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

resource "aws_security_group" "test-securitygroup-elb" {
  name        = "allow_tls2"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.networking.vpc-id

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


resource "aws_security_group" "test-securitygroup" {
  name        = "allow_tls1"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.networking.vpc-id

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

