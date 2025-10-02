resource "aws_iam_role" "gha_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : length(var.github_repos) > 0 ? [
      for repo in var.github_repos : {
        Effect : "Allow",
        Principal : {
          Federated : aws_iam_openid_connect_provider.github_actions.arn
        },
        Action : "sts:AssumeRoleWithWebIdentity",
        Condition : {
          StringLike : {
            "token.actions.githubusercontent.com:sub" : "repo:${var.github_org}/${repo}*"
          }
        }
      }
    ] : [
      {
        Effect : "Allow",
        Principal : {
          Federated : aws_iam_openid_connect_provider.github_actions.arn
        },
        Action : "sts:AssumeRoleWithWebIdentity",
        Condition : {
          StringLike : {
            "token.actions.githubusercontent.com:sub" : "repo:${var.github_org}/*"
          }
        }
      }
    ]
  })

  managed_policy_arns = var.iam_policy_arns

  tags = var.tags
}
