output "test-db-sg-id" {
  value = aws_security_group.test-db-securitygroup.id
  }

output "test-sg-id" {
  value = aws_security_group.test-securitygroup.id
  }


output "test-sg-elb-id" {
  value = aws_security_group.test-securitygroup-elb.id
  }
