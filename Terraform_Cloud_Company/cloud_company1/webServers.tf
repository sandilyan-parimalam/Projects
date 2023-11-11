resource "aws_instance" "web_servers" {
  #key_name               = "DLW01"
  ami                    = "ami-05c13eab67c5d8861"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.dev_web_subnet.id
  vpc_security_group_ids = [aws_security_group.dev_web_sg.id]
  depends_on             = [aws_internet_gateway.dev_web_igw]
  key_name               = "dev_web_keypair"
  tags = {
    Name = "DLW01"
  }

}