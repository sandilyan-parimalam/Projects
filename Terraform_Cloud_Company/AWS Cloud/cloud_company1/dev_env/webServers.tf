resource "aws_instance" "web_servers" {
  ami                    = var.web_server_instance_ami
  instance_type          = var.web_server_instance_type
  subnet_id              = aws_subnet.dev_web_subnet.id
  vpc_security_group_ids = [aws_security_group.dev_web_sg.id]
  depends_on             = [aws_internet_gateway.dev_web_igw]
  key_name               = var.web_server_instance_key_name
  tags                   = var.web_server_instance_tags
}