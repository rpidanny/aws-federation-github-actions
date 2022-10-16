terraform {
  required_version = "~> 1.2.9"

  required_providers {
    aws = {
      version = "~> 4.30.0"
      source  = "hashicorp/aws"
    }
  }
}
