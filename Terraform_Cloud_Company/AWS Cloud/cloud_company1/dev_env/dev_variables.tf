variable "region" {
  default = "us-east-1"
}

variable "budget_limit_amount" {
  default = "10.0"
}

variable "budget_limit_unit" {
  default = "USD"
}

variable "budget_time_unit" {
  default = "MONTHLY"
}

variable "budget_time_period_start" {
  default = "2023-11-09_00:01"
}

variable "budget_type" {
  default = "COST"
}

variable "budget_name" {
  default = "devops_budget"
}


variable "vpc_cidr_block" {
  default = "10.10.0.0/16"
}

variable "vpc_name" {
  default = "dev_vpc"
}

variable "web_subnet_cidr_block" {
  default = "10.10.1.0/24"
}

variable "web_subnet_name" {
  default = "dev_web_subnet"
}

variable "internet_gateway_name" {
  default = "dev_web_igw"
}

variable "route_table_name" {
  default = "dev_web_rt"
}

variable "route_table_association_name" {
  default = "dev_web_rt_association"
}

variable "security_group_name" {
  default = "dev_web_sg"
}

variable "security_group_description" {
  default = "Security Group for Dev Web environment"
}

variable "ssh_ingress_description" {
  default = "all ssh traffic from internet"
}

variable "ssh_ingress_from_port" {
  default = "22"
}

variable "ssh_ingress_to_port" {
  default = "22"
}

variable "ssh_ingress_protocol" {
  default = "tcp"
}

variable "ssh_ingress_cidr_blocks" {
  default = ["0.0.0.0/0"]
}

variable "default_route_cidr_block" {
  default = "0.0.0.0/0"
}

variable "web_server_instance_ami" {
  default = "ami-05c13eab67c5d8861"
}

variable "web_server_instance_type" {
  default = "t2.micro"
}


variable "web_server_instance_key_name" {
  default = "dev_web_keypair"
}

variable "web_server_instance_tags" {
  default = {
    Name = "DLW01"
  }
}
