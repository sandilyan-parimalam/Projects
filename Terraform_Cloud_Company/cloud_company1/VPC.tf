resource "aws_vpc" "dev_vpc" {

  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "dev_vpc"
  }

}

resource "aws_subnet" "dev_web_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "dev_web_subnet"
  }
}

resource "aws_internet_gateway" "dev_web_igw" {

  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "dev_web_igw"
  }
}

resource "aws_route_table" "dev_web_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_web_igw.id
  }
  tags = {
    Name = "dev_web_rt"
  }
}

resource "aws_route_table_association" "dev_web_rt_association" {
  subnet_id      = aws_subnet.dev_web_subnet.id
  route_table_id = aws_route_table.dev_web_rt.id

}

resource "aws_security_group" "dev_web_sg" {
  name        = "dev_web_sg"
  description = "Security Group for Dev Web environment"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "all ssh traffic from internet"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Security Group for Dev Web environment"
  }
}
