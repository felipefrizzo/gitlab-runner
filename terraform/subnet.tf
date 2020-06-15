data "aws_subnet_ids" "private_subnet" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = var.private_subnet_name
  }
}

data "aws_subnet_ids" "public_subnet" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = var.public_subnet_name
  }
}