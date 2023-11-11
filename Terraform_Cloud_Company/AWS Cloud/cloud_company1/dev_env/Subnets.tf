resource "aws_subnet" "dev_web_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.web_subnet_cidr_block
  map_public_ip_on_launch = true
  tags = {
    Name = var.web_subnet_name
  }
}