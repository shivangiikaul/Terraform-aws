resource "aws_codedeploy_app" "test-codedeploy-app" {
  name = "test-codedeploy-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "test-codedeploy-asg" {
  app_name              = aws_codedeploy_app.test-codedeploy-app.name
  deployment_group_name = "code-deploy-group"
  service_role_arn      = var.code-deploy-trust-arn
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  ec2_tag_set {
    ec2_tag_filter {
      key   = "name"
      type  = "KEY_AND_VALUE"
      value = "app_server"
    }

  }
  load_balancer_info {
    elb_info {
      name = var.test-elb-name
    }
  }
 
}

