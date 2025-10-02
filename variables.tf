variable "github_org" {
  type        = string
  description = "Name of the github organization you want to allow access to"
}

variable "github_repos" {
  type        = list(string)
  description = "List of github repositories you want to allow access to"
  default     = []
}

variable "iam_role_name" {
  type        = string
  description = "Name to use when creating the IAM role that GitHub Actions can assume"
}

variable "iam_policy_arns" {
  type        = list(string)
  description = "List of IAM policy ARNs that is attached to the IAM role"
  default     = []
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Respource Tags"
}
