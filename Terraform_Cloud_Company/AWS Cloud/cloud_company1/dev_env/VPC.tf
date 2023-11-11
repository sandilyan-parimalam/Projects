resource "aws_vpc" "dev_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "dev_web_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.web_subnet_cidr_block
  map_public_ip_on_launch = true
  tags = {
    Name = var.web_subnet_name
  }
}

resource "aws_internet_gateway" "dev_web_igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = var.internet_gateway_name
  }
}

resource "aws_route_table" "dev_web_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block = var.default_route_cidr_block
    gateway_id = aws_internet_gateway.dev_web_igw.id
  }
  tags = {
    Name = var.route_table_name
  }
}

resource "aws_route_table_association" "dev_web_rt_association" {
  subnet_id      = aws_subnet.dev_web_subnet.id
  route_table_id = aws_route_table.dev_web_rt.id
}

resource "aws_security_group" "dev_web_sg" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = var.ssh_ingress_description
    from_port   = var.ssh_ingress_from_port
    to_port     = var.ssh_ingress_to_port
    protocol    = var.ssh_ingress_protocol
    cidr_blocks = var.ssh_ingress_cidr_blocks
  }

  tags = {
    Name = var.security_group_name
  }
}
