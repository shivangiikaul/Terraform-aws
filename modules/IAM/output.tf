output "test-profile-name" {
  value = aws_iam_instance_profile.test_profile.name 
}

output "code-deploy-trust-arn" {
 value = aws_iam_role.code-deploy-trust.arn
 }

