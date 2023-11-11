resource "aws_route_table" "dev_web_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block = var.any_source_cidr_block
    gateway_id = aws_internet_gateway.dev_web_igw.id
  }
  tags = {
    Name = var.route_table_name
  }
}
