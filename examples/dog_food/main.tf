module "aws_federation_github_actions" {
  source = "../../"

  github_org = "rpidanny"

  iam_role_name   = "automation-gha-ci"
  iam_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]

  tags = local.tags
}
