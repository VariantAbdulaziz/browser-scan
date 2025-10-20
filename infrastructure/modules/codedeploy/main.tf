resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy-service-role"

  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role.json
}

data "aws_iam_policy_document" "codedeploy_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "codedeploy_attach" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_codedeploy_app" "django_app" {
  name             = "${var.namespace}-codedeploy-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "django_group" {
  app_name              = aws_codedeploy_app.django_app.name
  deployment_group_name = "${var.namespace}-group"
  service_role_arn      = aws_iam_role.codedeploy_role.arn

  ec2_tag_set {
    dynamic "ec2_tag_filter" {
      for_each = var.ec2_tags
      content {
        key   = ec2_tag_filter.key
        value = ec2_tag_filter.value
        type  = "KEY_AND_VALUE"
      }
    }
  }

  deployment_style {
    deployment_type   = "IN_PLACE"
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
  }
}
