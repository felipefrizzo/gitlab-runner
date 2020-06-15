resource "aws_security_group" "runner" {
  name        = format("scg-ec2-%s", local.project_name)
  description = format("Allow traffic from gitlab runner to %s machines", var.name)
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.runner.id
}

resource "aws_security_group_rule" "docker" {
  type                     = "ingress"
  from_port                = 2376
  to_port                  = 2376
  protocol                 = "tcp"
  security_group_id        = aws_security_group.runner.id
  source_security_group_id = aws_security_group.runner.id
}