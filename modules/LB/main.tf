module "networking" {
 source = "../networking"
 }

module "SECURITY-GROUPS" {
 source = "../SECURITY-GROUPS"
 }


resource "aws_lb_target_group" "test-targetgroups" {
  name     = "test-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.networking.vpc-id
}

resource "aws_lb" "test-elb" {
  name               = "test-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.SECURITY-GROUPS.test-sg-elb-id]
  subnets            = [ module.networking.test-subnet, module.networking.test-subnet2 ]
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
