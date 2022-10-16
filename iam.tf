resource "aws_iam_role" "gha_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          Federated : aws_iam_openid_connect_provider.github_actions.arn
        },
        Action : "sts:AssumeRoleWithWebIdentity",
        Condition : {
          StringLike : {
            "token.actions.githubusercontent.com:sub" : "repo:${var.github_org}/${var.github_repo}*"
          }
        }
      }
    ]
  })

  managed_policy_arns = var.iam_policy_arns

  tags = var.tags
}
