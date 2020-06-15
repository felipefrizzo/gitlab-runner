data "template_file" "runner" {
  template = file("${path.module}/user_data/template.tpl")

  vars = {
    ENVIRONMENT = var.environment

    GITLAB_RUNNER_CONCURRENCY  = var.gitlab_runner_concurrency
    GITLAB_RUNNER_IDLE_COUNT   = var.gitlab_runner_idle_count
    GITLAB_RUNNER_LIMIT        = 8
    GITLAB_RUNNER_MANAGER_NAME = local.project_name
    GITLAB_RUNNER_TOKEN        = var.gitlab_runner_token
    GITLAB_RUNNER_URL          = var.gitlab_runner_url
    GITLAB_RUNNER_MAX_BUILDS   = 8

    AWS_VPC_ID         = data.aws_vpc.default.id
    AWS_SUBNET_ID      = element(tolist(data.aws_subnet_ids.private_subnet.ids), 2)
    AWS_SECURITY_GROUP = aws_security_group.runner.name

    BUCKET_NAME = aws_s3_bucket.runner.id

    AWS_DEFAULT_REGION = data.aws_region.default.name
    AWS_INSTANCE_TYPE  = var.gitlab_runner_instance_type

    AWS_REQUEST_SPOT_INSTANCE = var.request_spot_instance
    AWS_SPOT_PRICE            = var.spot_price

    ROOT_DISK_SIZE = var.runner_root_disk_size
  }
}

data "aws_ami" "runner" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["ami-gitlab-runner-*"]
  }
}

resource "aws_instance" "runner" {
  ami                    = data.aws_ami.runner.id
  instance_type          = "t3a.small"
  vpc_security_group_ids = [aws_security_group.runner.id]
  subnet_id              = element(tolist(data.aws_subnet_ids.public_subnet.ids), 1)
  key_name               = var.key_name
  monitoring             = true

  associate_public_ip_address = true

  user_data = data.template_file.runner.rendered

  iam_instance_profile = aws_iam_instance_profile.runner.name

  root_block_device {
    volume_size = "8"
    volume_type = "gp2"
  }

  tags = {
    Name        = local.project_name
    ManagedBy   = "Terraform"
    Environment = var.environment
  }

  lifecycle {
    ignore_changes        = [subnet_id]
    create_before_destroy = true
  }
}