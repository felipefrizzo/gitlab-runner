output "bucket_name" {
  value       = aws_s3_bucket.runner.id
  description = "The name of the bucket."
}

output "bucket_arn" {
  value       = aws_s3_bucket.runner.arn
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
}

output "instance_id" {
  value       = aws_instance.runner.id
  description = "The instance ID."
}

output "instance_arn" {
  value       = aws_instance.runner.arn
  description = "The ARN of the instance."
}

output "instance_public_ip" {
  value       = aws_instance.runner.public_ip
  description = "The public IP address assigned to the instance, if applicable."
}

output "instance_private_ip" {
  value       = aws_instance.runner.private_ip
  description = "The private IP address assigned to the instance."
}