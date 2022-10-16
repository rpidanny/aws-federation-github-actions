output "iam_openid_connect_provider" {
  value       = aws_iam_openid_connect_provider.github_actions
  description = "The created OpenId Connect provider"
}

output "iam_role" {
  value       = aws_iam_role.gha_role
  description = "The created IAM Role"
}
