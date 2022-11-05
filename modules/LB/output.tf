output "test-targetgroups" {
  value = aws_lb_target_group.test-targetgroups.arn
  }

output "test-elb-name" {
 value = aws_lb.test-elb.name
 }
  
