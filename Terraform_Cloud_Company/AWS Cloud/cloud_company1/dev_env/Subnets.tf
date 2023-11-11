resource "aws_subnet" "dev_web_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.web_subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.web_subnet_az
  tags = {
    Name = var.web_subnet_name
  }
}

resource "aws_subnet" "dev_web_subnet_1" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.web_subnet_1_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.web_subnet_1_az
  tags = {
    Name = var.web_subnet_1_name
  }
}