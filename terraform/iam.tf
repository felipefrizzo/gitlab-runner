data "aws_iam_policy_document" "runner_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "runner_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:DeleteObject*",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      aws_s3_bucket.runner.arn,
      "${aws_s3_bucket.runner.arn}/*",
    ]
  }

  statement {
    effect    = "Allow"

    actions = [
      "ec2:AssociateIamInstanceProfile",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CancelSpotInstanceRequests",
      "ec2:CreateTags",
      "ec2:DeleteKeyPair",
      "ec2:DescribeInstances",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSpotInstanceRequests",
      "ec2:DescribeSubnets",
      "ec2:ImportKeyPair",
      "ec2:RequestSpotInstances",
      "ec2:RunInstances",
      "ec2:StartInstances",
      "iam:PassRole",
    ]

    resources = ["*"]
  }

  statement {
    effect    = "Allow"

    actions = [
      "ec2:RebootInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/ManagedBy"

      values = [
        "gitlab-runner"
      ]
    }

    resources = ["*"]
  }
}

resource "aws_iam_role" "runner" {
  name               = format("%s-role", local.project_name)
  assume_role_policy = data.aws_iam_policy_document.runner_role.json
}

resource "aws_iam_role_policy" "runner" {
  name   = format("%s-policy", local.project_name)
  role   = aws_iam_role.runner.name
  policy = data.aws_iam_policy_document.runner_policy.json
}

resource "aws_iam_instance_profile" "runner" {
  name = format("%s-instance-profile", local.project_name)
  role = aws_iam_role.runner.name
}