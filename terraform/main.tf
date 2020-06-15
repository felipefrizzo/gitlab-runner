provider "aws" {
  region  = "us-east-1"
  version = "~> 2.0"

  # skipping to improve times
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

locals {
  project_name = format("%s-%s", var.name, var.environment)
}

data "aws_region" "default" {}