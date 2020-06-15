resource "aws_s3_bucket" "runner" {
  bucket = local.project_name
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = local.project_name
    ManagedBy   = "Terraform"
    Environment = var.environment
  }
}