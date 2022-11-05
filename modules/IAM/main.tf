
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

resource "aws_iam_role" "code-deploy-trust" {
  name = "code-deploy-trust"

  assume_role_policy = file("/terraform/otherfiles/trust-policy-codedeploy")
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.code-deploy-trust.name
}

