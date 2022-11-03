module "networking" {
 source "../networking"
}


resource "aws_lb_target_group" "test-targetgroups" {
  name     = "test-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.test-vpc.id
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
