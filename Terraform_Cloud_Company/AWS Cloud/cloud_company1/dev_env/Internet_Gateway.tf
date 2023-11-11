resource "aws_internet_gateway" "dev_web_igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = var.internet_gateway_name
  }
}
