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
